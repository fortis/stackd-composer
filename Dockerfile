FROM alpine:edge
MAINTAINER Alan Bondarchuk <imacoda@gmail.com>

# Install packages
RUN echo 'http://alpine.gliderlabs.com/alpine/edge/main' > /etc/apk/repositories && \
    echo 'http://alpine.gliderlabs.com/alpine/edge/community' >> /etc/apk/repositories && \
    echo 'http://alpine.gliderlabs.com/alpine/edge/testing' >> /etc/apk/repositories && \

    apk add --update \
        libressl \
        ca-certificates \
        openssh-client \
        git \
        curl \
        unzip \
        php7 \
        php7-pcntl \
        php7-json \
        php7-phar \
        php7-iconv \
        php7-openssl \
        php7-zip \
        && \

    # Create symlinks for backward compatibility
    ln -sf /usr/bin/php7 /usr/bin/php && \

    # Install composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer && \
    composer global require hirak/prestissimo --optimize-autoloader && \

    # Cleanup
    apk del --purge \
        *-dev \
        build-base \
        autoconf \
        libtool \
        curl \
        openssl \
        && \

    rm -rf \
        /usr/include/php \
        /usr/lib/php/build \
        /var/cache/apk/* \
        /tmp/* \
        /root/.composer

WORKDIR /var/www/html
VOLUME /var/www/html

# Command
CMD ["/usr/local/bin/composer", "--help"]
