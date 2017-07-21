# docker-magento-base

[![Docker Automated Build](https://img.shields.io/docker/automated/sensson/magento-base-1.svg)]() [![Docker Build Status](https://img.shields.io/docker/build/sensson/magento-base-1.svg)]()

A base Magento 1.9 image that can be used to scale in production. This can
be used in combination with MySQL and Redis. It is opiniated and includes
support for Composer, ionCube, Redis and the required PHP modules for a basic 
Magento installation.

It does not include Magento. 

# Usage

An example `Dockerfile`

```
FROM sensson/magento-base-1
COPY src/ /var/www/html/
```

# Persistent storage

The container assumes you do not store data in a folder along with the
application. Don't use Docker volumes for scale. Use CephFS, GlusterFS or
integrate with S3 or S3-compatible services such as Fuga.io.

# Configuration

## local.xml

Once the container starts it will always change `app/etc/local.xml` to the
credentials that were specified as environment variable. You should never have
to save your credentials in git. Stay safe.

You can leave some settings empty such as your encryption key:

```
<crypt>
    <key></key>
</crypt>
```

and your database details:

```
<resources>
    <db>
        <table_prefix></table_prefix>
    </db>
    <default_setup>
        <connection>
            <host></host>
            <username></username>
            <password></password>
            <dbname></dbname>
            <active>1</active>
        </connection>
    </default_setup>
</resources>
```

Do not remove the settings completely and leave `local.xml` in place.

## Environment variables

Environment variable  | Description                   | Default
--------------------  | -----------                   | -------
MYSQL_HOSTNAME        | MySQL hostname                | Empty
MYSQL_USERNAME        | MySQL username                | Empty
MYSQL_PASSWORD        | MySQL password                | Empty
MYSQL_DATABASE        | MySQL database                | Empty
TABLE_PREFIX          | Table prefix                  | Empty
CRYPTO_KEY            | Magento Encryption key        | Emtpy
URI                   | Uri (e.g. http://localhost)   | Empty
RUNTYPE               | Set to development to enable  | Empty

## Development mode

Setting `RUNTYPE` to `development` will turn on public error reports. Anything
else will leave it off. It will also set `display_errors` to on in PHP. This is
set to off by default.
