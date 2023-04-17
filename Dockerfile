# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.17

# set version label
ARG BUILD_DATE
ARG VERSION
ARG NEXTCLOUD_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache --upgrade \
    ffmpeg \
    gnu-libiconv \
    imagemagick \
    libxml2 \
    php81-apcu \
    php81-bcmath \
    php81-bz2 \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-ftp \
    php81-gd \
    php81-gmp \
    php81-iconv \
    php81-imap \
    php81-intl \
    php81-ldap \
    php81-opcache \
    php81-pcntl \
    php81-pdo_mysql \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-pecl-imagick \
    php81-pecl-memcached \
    php81-pgsql \
    php81-phar \
    php81-posix \
    php81-redis \
    php81-sodium \
    php81-sqlite3 \
    php81-sysvsem \
    php81-xmlreader \
    php81-zip \
    samba-client \
    sudo && \
  apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    php81-pecl-smbclient && \
  apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php81-pecl-mcrypt && \
  echo "**** configure php and nginx for nextcloud ****" && \
  echo 'apc.enable_cli=1' >> /etc/php81/conf.d/apcu.ini && \
  sed -i \
    -e 's/;opcache.enable.*=.*/opcache.enable=1/g' \
    -e 's/;opcache.interned_strings_buffer.*=.*/opcache.interned_strings_buffer=16/g' \
    -e 's/;opcache.max_accelerated_files.*=.*/opcache.max_accelerated_files=10000/g' \
    -e 's/;opcache.memory_consumption.*=.*/opcache.memory_consumption=128/g' \
    -e 's/;opcache.save_comments.*=.*/opcache.save_comments=1/g' \
    -e 's/;opcache.revalidate_freq.*=.*/opcache.revalidate_freq=1/g' \
    -e 's/;always_populate_raw_post_data.*=.*/always_populate_raw_post_data=-1/g' \
    -e 's/memory_limit.*=.*128M/memory_limit=512M/g' \
    -e 's/max_execution_time.*=.*30/max_execution_time=120/g' \
    -e 's/upload_max_filesize.*=.*2M/upload_max_filesize=1024M/g' \
    -e 's/post_max_size.*=.*8M/post_max_size=1024M/g' \
    -e 's/output_buffering.*=.*/output_buffering=0/g' \
      /etc/php81/php.ini && \
  sed -i \
    '/opcache.enable=1/a opcache.enable_cli=1' \
      /etc/php81/php.ini && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php81/php-fpm.conf && \
  echo "**** set version tag ****" && \
  if [ -z ${NEXTCLOUD_RELEASE+x} ]; then \
    NEXTCLOUD_RELEASE=$(curl -sX GET https://api.github.com/repos/nextcloud/server/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]' \
      | sed 's|^v||'); \
  fi && \
  echo "**** download nextcloud ****" && \
  curl -o /app/nextcloud.tar.bz2 -L \
    https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_RELEASE}.tar.bz2 && \
  echo "**** test tarball ****" && \
    tar xvf /app/nextcloud.tar.bz2 -C \
      /tmp && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
