#!/bin/bash

DOCUMENT_ROOT=$(dirname ${APACHE_DOCUMENT_ROOT})

# set default database port if undefined
case "${POSTFIXADMIN_DATABASE_TYPE}" in
  sqlite)
    ;;
  mysqli)
    : "${POSTFIXADMIN_DATABASE_PORT:=3306}"
    ;;
  pgsql)
    : "${POSTFIXADMIN_DATABASE_PORT:=5432}"
    : "${POSTFIXADMIN_DATABASE_NAME:=postgres}"
  ;;
  *)
  echo >&2 "${POSTFIXADMIN_DATABASE_TYPE} is not a supported value."
  exit 1
  ;;
esac

# check if database user and password is defined and if database answer of an icmp ping
if [ "${POSTFIXADMIN_DATABASE_TYPE}" != "sqlite" ]; then
  if [ -z "${POSTFIXADMIN_DATABASE_USER}" -o -z "${POSTFIXADMIN_DATABASE_PASSWORD}" ]; then
    echo >&2 'Error: POSTFIXADMIN_DATABASE_USER and POSTFIXADMIN_DATABASE_PASSWORD must be specified. '
    exit 1
  fi
  timeout 15 bash -c "until echo > /dev/tcp/${POSTFIXADMIN_DATABASE_HOST}/${POSTFIXADMIN_DATABASE_PORT}; do sleep 0.5; done"
fi

# create sqlite.db if sqlite is specified as backend
if [ "${POSTFIXADMIN_DATABASE_TYPE}" = 'sqlite' ]; then
  export POSTFIXADMIN_DATABASE_NAME=${POSTFIXADMIN_DATABASE_NAME:=/var/tmp/postfixadmin.db}

  if [ ! -f "${POSTFIXADMIN_DATABASE_NAME}" ]; then
    echo "Create sqlite database: ${POSTFIXADMIN_DATABASE_NAME}"
    touch ${POSTFIXADMIN_DATABASE_NAME}
    chown www-data:www-data ${POSTFIXADMIN_DATABASE_NAME}
    chmod 0700 ${POSTFIXADMIN_DATABASE_NAME}
  fi
fi

# bycrypt POSTFIXADMIN_SETUP_PASSWORD
if [ ! -z ${POSTFIXADMIN_SETUP_PASSWORD+x} ]; then
  POSTFIXADMIN_SETUP_PASSWORD=$(htpasswd -bnBC 10 "" "${POSTFIXADMIN_SETUP_PASSWORD}" | tr -d ':\n')
fi

# create config.local.pgp with vaules from env with POSTFIXADMIN_ prefix
POSTFIXADMIN_ENV_VARS=($(env | sort | grep --perl-regexp '^POSTFIXADMIN_.*'))

cat > ${DOCUMENT_ROOT}/config.local.php <<EOF
<?php
  \$CONF['configured'] = true;
EOF

for ENV_VAR in ${POSTFIXADMIN_ENV_VARS[@]}; do
  KEY=$(echo ${ENV_VAR} | cut --delimiter="=" --fields="1" | sed 's/POSTFIXADMIN_//' | tr '[:upper:]' '[:lower:]')
  VALUE=$(echo ${ENV_VAR} | cut --delimiter="=" --fields="2")

  echo "  \$CONF['${KEY}'] = '${VALUE}';" >> ${DOCUMENT_ROOT}/config.local.php
done

cat >> ${DOCUMENT_ROOT}/config.local.php <<EOF
?>
EOF

chown www-data: ${DOCUMENT_ROOT}/config.local.php

# start database migration

if [ -f public/upgrade.php ]; then
  echo "Running database / environment upgrade.php "
  gosu www-data php public/upgrade.php
fi

exec "$@"
