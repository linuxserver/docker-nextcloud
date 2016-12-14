FROM lsiobase/alpine.nginx
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ENV NEXTCLOUD_VER="11.0.0"

# environment settings
ENV NEXTCLOUD_PATH="/config/www/nextcloud"

# install build-dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	file \
	g++ \
	gcc \
	make \
	php5-dev \
	re2c \
	samba-dev \
	zlib-dev && \

# install runtime packages
 apk add --no-cache \
	curl \
	ffmpeg \
	libxml2 \
	php5-apcu \
	php5-bz2 \
	php5-ctype \
	php5-curl \
	php5-dom \
	php5-exif \
	php5-ftp \
	php5-gd \
	php5-gmp \
	php5-iconv \
	php5-imap \
	php5-intl \
	php5-ldap \
	php5-mcrypt \
	php5-openssl \
	php5-pcntl \
	php5-pgsql \
	php5-pdo_mysql \
	php5-pdo_pgsql \
	php5-pdo_sqlite \
	php5-posix \
	php5-sqlite3 \
	php5-xml \
	php5-xmlreader \
	php5-zip \
	php5-zlib \
	samba \
	sudo \
	tar \
	unzip && \

 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	php5-memcached && \

# fetch php smbclient source
 git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \

# compile smbclient
 cd /tmp/smbclient && \
 phpize && \
 ./configure && \
	make && \
	make install && \

# uninstall build-dependencies
 apk del --purge \
	build-dependencies && \

# configure php and nginx for nextcloud
 echo "extension="smbclient.so"" >> /etc/php5/php.ini && \
 sed -i \
 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g' \
	/etc/php5/php.ini && \
 echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /defaults/nginx-fpm.conf && \

# cleanup
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 443
VOLUME /config /data
