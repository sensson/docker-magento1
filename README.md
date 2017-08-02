# docker-magento1

[![Docker Automated Build](https://img.shields.io/docker/automated/sensson/magento1.svg)](https://hub.docker.com/r/sensson/magento1/) [![Docker Build Status](https://img.shields.io/docker/build/sensson/magento1.svg)](https://hub.docker.com/r/sensson/magento1/)

A base Magento 1.9 image that can be used to scale in production. This can
be used in combination with MySQL and Redis. It is opiniated and includes
support for Composer, ionCube, Redis, OPcache, and the required PHP modules 
for a basic Magento installation.

It does not include Magento. 

# Usage

An example `Dockerfile`

```
FROM sensson/magento1
COPY src/ /var/www/html/
```

# Persistent storage

The container assumes you do not store data in a folder along with the
application. Don't use Docker volumes for scale. Use CephFS, GlusterFS or
integrate with S3 or S3-compatible services such as [Fuga.io](https://fuga.io).

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

Do not remove the settings completely and always leave `local.xml` in place.
Once the container starts it will automatically populate all required fields.

## Environment variables

Environment variable  | Description                   | Default
--------------------  | -----------                   | -------
MYSQL_HOSTNAME        | MySQL hostname                | mysql
MYSQL_USERNAME        | MySQL username                | root
MYSQL_PASSWORD        | MySQL password                | random
MYSQL_DATABASE        | MySQL database                | magento
TABLE_PREFIX          | Table prefix                  | Empty
CRYPTO_KEY            | Magento Encryption key        | Emtpy
URI                   | Uri (e.g. http://localhost)   | http://localhost
RUNTYPE               | Set to development to enable  | Empty

Include the port mapping in `URI` if you run your shop on a local development
environment, e.g. `http://localhost:3000/`.

## Development mode

Setting `RUNTYPE` to `development` will turn on public error reports. Anything
else will leave it off. It will also set `display_errors` to on in PHP. This is
set to off by default.
