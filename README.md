# PostfixAdmin

[![Build Status](https://drone.cryptic.systems/api/badges/volker.raschek/postfixadmin-docker/status.svg)](https://drone.cryptic.systems/volker.raschek/postfixadmin-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/postfixadmin)](https://hub.docker.com/r/volkerraschek/postfixadmin)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/volker-raschek)](https://artifacthub.io/packages/search?repo=volker-raschek)

This is an alternative project to build a container image for
[PostfixAdmin](https://github.com/postfixadmin/postfixadmin).

The main goal of this alternative image is to support a kubernetes deployment
via helm. Furthermore, the container image support configuring via [environment
variables](#supported-environment-variables).

To deploy PostfixAdmin via `helm` checkout the repository on
[artifacthub.io](https://artifacthub.io/packages/helm/volker-raschek/postfixadmin)
for more details.

## Supported environment variables

This list is an overview over some important environment variables. The
environment variables are composed on the key of the PHP configuration with the
prefix `POSTFIXADMIN_`. You can take an example
[configuration](https://github.com/postfixadmin/postfixadmin/blob/master/config.inc.php)
from the upstream project.

| name                                | default                                     |
| ----------------------------------- | ------------------------------------------- |
| `POSTFIXADMIN_ADMIN_EMAIL`          |                                             |
| `POSTFIXADMIN_ADMIN_SMTP_PASSWORD`  |                                             |
| `POSTFIXADMIN_ADMIN_NAME`           |                                             |
| `POSTFIXADMIN_DATABASE_TYPE`        | `sqlite`                                    |
| `POSTFIXADMIN_DATABASE_USER`        |                                             |
| `POSTFIXADMIN_DATABASE_PASSWORD`    |                                             |
| `POSTFIXADMIN_DATABASE_HOST`        |                                             |
| `POSTFIXADMIN_DATABASE_PORT`        |                                             |
| `POSTFIXADMIN_DATABASE_NAME`        | `/var/tmp/postfixadmin.db`                  |
| `POSTFIXADMIN_DEFAULT_LANGUAGE`     | `en`                                        |
| `POSTFIXADMIN_DATABASE_USE_SSL`     |                                             |
| `POSTFIXADMIN_DATABASE_KEY`         |                                             |
| `POSTFIXADMIN_DATABASE_CERT`        |                                             |
| `POSTFIXADMIN_DATABASE_CA`          |                                             |
| `POSTFIXADMIN_DATABASE_PREFIX`      |                                             |
| `POSTFIXADMIN_ENCRYPT`              | `md5crypt`                                  |
| `POSTFIXADMIN_SMTP_SERVER`          | `localhost`                                 |
| `POSTFIXADMIN_SMTP_PORT`            | `25`                                        |
| `POSTFIXADMIN_SMTP_CLIENT`          |                                             |
| `POSTFIXADMIN_SHOW_FOOTER_TEXT`     | `YES`                                       |
| `POSTFIXADMIN_FOOTER_TEXT`          | `Return to change-this-to-your.domain.tld`  |
| `POSTFIXADMIN_FOOTER_LINK`          | `http://change-this-to-your.domain.tld`     |
| `POSTFIXADMIN_FETCHMAIL`            | `YES`                                       |

### POSTFIXADMIN_ADMIN_EMAIL

Define the email address of an admin via `POSTFIXADMIN_ADMIN_EMAIL` to send
emails or broadcast messages in his name instead of the email address of the
logged in admin, which wants to send an email or broadcast message about the
PostfixAdmin interface. By default is the environment variable not defined. The
value of the environment will be configured as the following config setting:
`$CONF['admin_email']`.

### POSTFIXADMIN_ADMIN_SMTP_PASSWORD

Define the smtp password via `POSTFIXADMIN_ADMIN_SMTP_PASSWORD` of the admin
which should be used to send emails or broadcast messages about the PostfixAdmin
interface. By default is the environment variable not defined. The value of the
environment will be configured as the following config setting:
`$CONF['admin_smtp_password']`.

### POSTFIXADMIN_ADMIN_NAME

Define the name of the admin via `POSTFIXADMIN_ADMIN_NAME` which should be used
to send emails or broadcast messages about the PostfixAdmin interface. By
default is the environment variable not defined. The value of the environment
will be configured as the following config setting: `$CONF['admin_name']`.

### POSTFIXADMIN_DATABASE_TYPE

PostfixAdmin support currently sqlite, postgres and mysql/mariadb. About the
envrionment variable `POSTFIXADMIN_DATABASE_TYPE` can the backend type defined.
The default value is `sqlite`.

| database type | value     |
| ------------- | --------- |
| mysql/mariadb | `mysqli`  |
| postgres      | `pgsql`   |
| sqlite        | `sqlite`  |

### POSTFIXADMIN_DATABASE_USER

The environment variable `POSTFIXADMIN_DATABASE_USER` is undefined and only
required if the database backend is not `sqlite`. The value of the environment
will be configured as the following config setting: `$CONF['database_user']`.

### POSTFIXADMIN_DATABASE_PASSWORD

The environment variable `POSTFIXADMIN_DATABASE_PASSWORD` is undefined and only
required if the database backend is not `sqlite`. The value of the environment
will be configured as the following config setting: `$CONF['database_password']`.

### POSTFIXADMIN_DATABASE_HOST

The environment variable `POSTFIXADMIN_DATABASE_HOST` is undefined and only
required if the database backend is not `sqlite`. The value of the environment
will be configured as the following config setting: `$CONF['database_host']`.

### POSTFIXADMIN_DATABASE_PORT

The environment variable `POSTFIXADMIN_DATABASE_PORT` will automatically defined
with default values when instead of `sqlite` an other database backend has been
selected. The value of the environment will be configured as the following
config setting: `$CONF['database_port']`.

| database type   | default port  |
| --------------- | ------------- |
| mysqli/mariadb  | `3306`        |
| postgres        | `5432`        |

### POSTFIXADMIN_DATABASE_NAME

The environment variable `POSTFIXADMIN_DATABASE_NAME` is defined by default with
the value `/var/tmp/postfixadmin.db`. This is the path where the `sqlite`
database is stored. If `pgsql` or `mysqli` is defined instead of `sqlite` as
database backend type, can the environment variable used to define the database
name. The value of the environment will be configured as the following config
setting: `$CONF['database_name']`.

### POSTFIXADMIN_DATABASE_USE_SSL

Encrypt a database connection to an external database like postgres, mariadb or
mysqli via SSL when `POSTFIXADMIN_DATABASE_USE_SSL=true`. Additionally should be
the other SSL environment variables defined to establish successfully a SSL
encrypted connection. The value of the environment will be configured as the
following config setting: `$CONF['database_use_ssl']`.

### POSTFIXADMIN_DATABASE_SSL_KEY

Via `POSTFIXADMIN_DATABASE_SSL_KEY` can be the path to the private key defined
which should be used to encrypt the database connection via SSL. By default is
this environment variable undefined. The value of the environment will be
configured as the following config setting: `$CONF['database_ssl_key']`.

### POSTFIXADMIN_DATABASE_SSL_CERT

Via `POSTFIXADMIN_DATABASE_SSL_CERT` can be the path to the certificate defined
which should be used to encrypt the database connection via SSL. By default is
this environment variable undefined. The value of the environment will be
configured as the following config setting: `$CONF['database_ssl_cert']`.

### POSTFIXADMIN_DATABASE_SSL_CA

Via `POSTFIXADMIN_DATABASE_SSL_CA` can be the path to the root certificate of
the certificate authority defined which should be trusted to encrypt the database
connection via SSL. By default is this environment variable undefined. The value
of the environment will be configured as the following config setting:
`$CONF['database_ssl_ca']`.

### POSTFIXADMIN_DATABASE_PREFIX

It make much sense to use a prefix name for all PostfixAdmin related tables,
when the tables, views and so on should be stored into a shared schema like
`public`. About the environment variable `POSTFIXADMIN_DATABASE_PREFIX` can such
a prefix defined. By default is this variable undefined, but when not it results
in the config setting `$CONF['database_prefix']`.

### POSTFIXADMIN_DEFAULT_LANGUAGE

Default language of PostfixAdmin. Checkout the [official
repository](https://github.com/postfixadmin/postfixadmin/tree/master/languages)
under `./languages` to get a list of all supported languages.

### POSTFIXADMIN_ENCRYPT

Via `POSTFIXADMIN_ENCRYPT` can be the algorithm specified to encrypt passwords
of users. The algorithm `md5crypt` is defined as default. Other possible values
are documented
[here](https://github.com/postfixadmin/postfixadmin/blob/master/DOCUMENTS/HASHING.md).

### POSTFIXADMIN_SETUP_PASSWORD

To login into the `setup.php` page is the setup password required. This can be
defined via the variable `POSTFIXADMIN_SETUP_PASSWORD`. The password will not be
configured in the `config.local.php` as plain text. It will be encrypted.

### POSTFIXADMIN_SMTP_CLIENT

Hostname (FQDN) of the server hosting PostfixAdmin used in the `HELO` when
sending emails from PostfixAdmin. The value of the environment will be
configured as the following config setting: `$CONF['smtp_server']` and is empty
by default.

### POSTFIXADMIN_SMTP_SERVER

Hostname (FQDN) of your mail server. The default value is `localhost`. The value
of the environment will be configured as the following config setting:
`$CONF['smtp_server']`.

### POSTFIXADMIN_SMTP_PORT

Port of your mail server. The default value is `25`. The value of the
environment will be configured as the following config setting:
`$CONF['smtp_port']`.

### POSTFIXADMIN_SHOW_FOOTER_TEXT

Enable or disable via `YES` or `NO` the footer text displayed on all sites. Use
`POSTFIXADMIN_FOOTER_TEXT` and `POSTFIX_FOOTER_LINK` to customize the text.

### POSTFIXADMIN_FETCHMAIL

Enable or disable via `YES` or `NO` the fetchmail tab. It has nothing todo with
the fetchmail cron job.
