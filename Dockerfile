# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.18

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
  apk add --no-cache \
    ffmpeg \
    gnu-libiconv \
    imagemagick \
    libxml2 \
    php82-apcu \
    php82-bcmath \
    php82-bz2 \
    php82-dom \
    php82-exif \
    php82-ftp \
    php82-gd \
    php82-gmp \
    php82-imap \
    php82-intl \
    php82-ldap \
    php82-opcache \
    php82-pcntl \
    php82-pdo_mysql \
    php82-pdo_pgsql \
    php82-pdo_sqlite \
    php82-pecl-imagick \
    php82-pecl-memcached \
    php82-pecl-smbclient \
    php82-pgsql \
    php82-posix \
    php82-redis \
    php82-sodium \
    php82-sqlite3 \
    php82-sysvsem \
    php82-xmlreader \
    samba-client \
    sudo && \
  apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php82-pecl-mcrypt && \
  echo "**** configure php and nginx for nextcloud ****" && \
  echo 'apc.enable_cli=1' >> /etc/php82/conf.d/apcu.ini && \
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
      /etc/php82/php.ini && \
  sed -i \
    '/opcache.enable=1/a opcache.enable_cli=1' \
      /etc/php82/php.ini && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php82/php-fpm.conf && \
  echo "**** set version tag ****" && \
  if [ -z ${NEXTCLOUD_RELEASE+x} ]; then \
    NEXTCLOUD_RELEASE=$(curl -sX GET https://api.github.com/repos/nextcloud/server/releases \
      | jq -r '.[] | select(.prerelease != true) | .tag_name' \
      | sed 's|^v||g' | sort -rV | head -1); \
  fi && \
  echo "${NEXTCLOUD_RELEASE}" >/app/NEXTCLOUD_RELEASE_INCLUDED && \
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
