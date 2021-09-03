FROM docker.io/library/php:7.4-apache

# POSTFIXADMIN VERSION
ARG POSTFIXADMIN_VERSION \
    POSTFIXADMIN_SHA512

# APACHE
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN set -eu; \
  sed --in-place --regexp-extended 's#/var/www/html#${APACHE_DOCUMENT_ROOT}#g' /etc/apache2/sites-available/*.conf; \
  sed --in-place --regexp-extended 's#/var/www/#${APACHE_DOCUMENT_ROOT}#g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# DEFAULT DATABASE SETTINGS
ENV POSTFIXADMIN_DATABASE_TYPE=sqlite \
    POSTFIXADMIN_DATABASE_HOST="" \
    POSTFIXADMIN_DATABASE_PORT="" \
    POSTFIXADMIN_DATABASE_USER="" \
    POSTFIXADMIN_DATABASE_PASSWORD="" \
    POSTFIXADMIN_SMTP_SERVER="localhost" \
    POSTFIXADMIN_SMTP_PORT="25" \
    POSTFIXADMIN_ENCRYPT="md5crypt"

# docker-entrypoint.sh dependencies
RUN set -eux; \
  apt-get update; \
  apt-get install --yes --no-install-recommends gosu apache2-utils; \
  rm --recursive --force /var/lib/apt/lists/*

# Install required PHP extensions
RUN set -ex; \
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  apt-get install --yes --no-install-recommends \
    libc-client2007e-dev \
    libkrb5-dev \
    libpq-dev \
    libsqlite3-dev; \
  docker-php-ext-configure imap --with-imap-ssl --with-kerberos; \
  docker-php-ext-install -j "$(nproc)" \
    imap \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql; \
  apt-mark auto '.*' > /dev/null; \
  apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
    | awk '/=>/ { print $3 }' \
    | sort -u \
    | xargs -r dpkg-query -S \
    | cut -d: -f1 \
    | sort -u \
    | xargs -rt apt-mark manual; \
  apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm --recursive --force /var/lib/apt/lists/*

RUN set -eu; \
  curl --fail --silent --show-error --location "https://github.com/postfixadmin/postfixadmin/archive/postfixadmin-${POSTFIXADMIN_VERSION}.tar.gz" --output postfixadmin.tar.gz ; \
  echo "${POSTFIXADMIN_SHA512} *postfixadmin.tar.gz" | sha512sum -c -; \
  tar --extract --file postfixadmin.tar.gz --directory /var/www/html --strip-components=1; \
  rm postfixadmin.tar.gz; \
  # Does not exist in tarball but is required
  mkdir --parents /var/www/html/templates_c; \
  chown --recursive www-data:www-data /var/www/html

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
