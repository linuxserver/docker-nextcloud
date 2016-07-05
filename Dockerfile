FROM lsiobase/alpine.nginx
MAINTAINER sparklyballs

# set paths
ENV WWW_ROOT="/config/www"
ENV NEXTCLOUD_PATH="${WWW_ROOT}/nextcloud"

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

# cleanup
 rm -rfv /tmp/*

# install runtime packages
RUN \
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
	php5-pdo_mysql \
	php5-pdo_pgsql \
	php5-pdo_sqlite \
	php5-pgsql \
	php5-posix \
	php5-sqlite3 \
	php5-xml \
	php5-xmlreader \
	php5-zip \
	php5-zlib \
	samba \
	tar \
	unzip && \
 apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
	php5-memcached

# configure php extensions
RUN \
 echo "extension="smbclient.so"" >> /etc/php5/php.ini

# configure php for nextcloud
RUN \
 sed -i \
 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g' \
	/etc/php5/php.ini && \
 echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /defaults/nginx-fpm.conf

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /data
EXPOSE 443

# set nextcloud version
ENV NEXTCLOUD_VER="9.0.52"
