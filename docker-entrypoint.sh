#!/bin/sh
set -e

if [ ! -f "lib/config.php" ]; then
    echo "Creating lib/config.php from template..."
    cp lib/config.template.php lib/config.php

    # Replace default configuration values with environment variables if set

    # Base URL
    if [ -n "$BASE_URL" ]; then
        sed -i "s|'http://micropubrocks.dev/'|'$BASE_URL'|g" lib/config.php
    fi

    # Redis
    if [ -n "$REDIS_URL" ]; then
        sed -i "s|'tcp://127.0.0.1:6379'|'$REDIS_URL'|g" lib/config.php
    fi

    # Database configuration
    if [ -n "$DB_HOST" ]; then
        sed -i "s|'127.0.0.1'|'$DB_HOST'|g" lib/config.php
    fi

    if [ -n "$DB_NAME" ]; then
        sed -i "s|'micropubrocks'|'$DB_NAME'|g" lib/config.php
    fi

    if [ -n "$DB_USER" ]; then
        # Use an alternate separator since usernames don't typically contain commas
        sed -i "s/public static \$dbuser = 'micropubrocks';/public static \$dbuser = '$DB_USER';/g" lib/config.php
    fi

    if [ -n "$DB_PASS" ]; then
        sed -i "s/public static \$dbpass = 'micropubrocks';/public static \$dbpass = '$DB_PASS';/g" lib/config.php
    fi

    # Secret
    if [ -n "$APP_SECRET" ]; then
        sed -i "s/'xxxx'/'$APP_SECRET'/g" lib/config.php
    fi
fi

exec "$@"
