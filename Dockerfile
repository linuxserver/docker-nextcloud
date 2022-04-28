FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14

# set version label
ARG BUILD_DATE
ARG VERSION
ARG NEXTCLOUD_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV NEXTCLOUD_PATH="/config/www/nextcloud" \
  LD_PRELOAD="/usr/lib/preloadable_libiconv.so"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies --upgrade \
    autoconf \
    automake \
    file \
    g++ \
    gcc \
    make \
    php7-dev \
    re2c \
    samba-dev \
    zlib-dev && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache --upgrade \
    curl \
    ffmpeg \
    gnu-libiconv \
    imagemagick \
    libxml2 \
    php7-apcu \
    php7-bcmath \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-ftp \
    php7-gd \
    php7-gmp \
    php7-iconv \
    php7-imagick \
    php7-imap \
    php7-intl \
    php7-ldap \
    php7-mcrypt \
    php7-memcached \
    php7-opcache \
    php7-pcntl \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-pgsql \
    php7-phar \
    php7-posix \
    php7-redis \
    php7-sodium \
    php7-sqlite3 \
    php7-xmlreader \
    php7-zip \
    samba-client \
    sudo \
    tar \
    unzip && \
  echo "**** compile smbclient ****" && \
  git clone https://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \
  cd /tmp/smbclient && \
  phpize7 && \
  ./configure \
    --with-php-config=/usr/bin/php-config7 && \
  make && \
  make install && \
  echo "**** configure php and nginx for nextcloud ****" && \
  echo "extension="smbclient.so"" > /etc/php7/conf.d/00_smbclient.ini && \
  echo 'apc.enable_cli=1' >> /etc/php7/conf.d/apcu.ini && \
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
      /etc/php7/php.ini && \
  sed -i \
    '/opcache.enable=1/a opcache.enable_cli=1' \
      /etc/php7/php.ini && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php7/php-fpm.conf && \
  echo "**** set version tag ****" && \
  if [ -z ${NEXTCLOUD_RELEASE+x} ]; then \
    NEXTCLOUD_RELEASE=$(curl -s https://raw.githubusercontent.com/nextcloud/nextcloud.com/master/strings.php \
    | awk -F\' '/VERSIONS_SERVER_FULL_STABLE/ {print $2;exit}'); \
  fi && \
  echo "**** download nextcloud ****" && \
  curl -o /app/nextcloud.tar.bz2 -L \
    https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_RELEASE}.tar.bz2 && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 443
VOLUME /config /data
