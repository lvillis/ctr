FROM alpine:3.13

ENV TIME_ZONE Asia/Shanghai
RUN true \
    # Any command which returns non-zero exit code will cause this shell script to exit immediately:
    && set -e \
    # Activate debugging to show execution details: all commands will be printed before execution
    && set -x \
    && echo "https://dl-4.alpinelinux.org/alpine/v3.13/main/" >> /etc/apk/repositories \
    && apk add --update --no-cache tzdata vim curl \
    && cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && echo "${TIME_ZONE}" > /etc/timezone \
    && apk del tzdata

# Install packages and remove default server definition
RUN true \
    # Any command which returns non-zero exit code will cause this shell script to exit immediately:
    && set -e \
    # Activate debugging to show execution details: all commands will be printed before execution
    && set -x \
    && apk add --no-cache \
            php8 \
            php8-ctype \
            php8-curl \
            php8-dom \
            php8-fpm \
            php8-gd \
            php8-opcache \
            php8-mysqli \
            php8-json \
            php8-openssl \
            php8-mbstring \
            php8-xml \
            php8-phar \
            php8-intl \
            php8-xmlreader \
            php8-zlib \
            php8-session \
            nginx \
            supervisor \
            curl \
    && rm /etc/nginx/conf.d/default.conf

ENV DIR nginx-php

# Configure nginx
COPY $DIR/config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY $DIR/config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY $DIR/config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY $DIR/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV RUNTIME_USER root

RUN true \
    # Any command which returns non-zero exit code will cause this shell script to exit immediately:
    && set -e \
    # Activate debugging to show execution details: all commands will be printed before execution
    && set -x \
    # Create symlink so programs depending on `php` still function
    && ln -s /usr/bin/php8 /usr/bin/php \
    # Setup document root
    && mkdir -p /var/www/html \
    # Make sure files/folders needed by the processes are accessable when they run under the nobody user
    && chown -R $RUNTIME_USER.$RUNTIME_USER /var/www/html \
    && chown -R $RUNTIME_USER.$RUNTIME_USER /run \
    && chown -R $RUNTIME_USER.$RUNTIME_USER /var/lib/nginx \
    && chown -R $RUNTIME_USER.$RUNTIME_USER /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html

COPY --chown=nobody $DIR/src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping