FROM lsiobase/alpine
MAINTAINER sparklyballs

# package version
ENV NEXTCLOUD_VER="10.0.0"

# install build-dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	file \
	g++ \
	gcc \
	make \
	re2c \
	samba-dev \
	zlib-dev && \

 apk add --no-cache --virtual=build-dependencies2 \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	php7-dev && \

# install runtime packages
 apk add --no-cache \
	curl \
	ffmpeg \
	git \
	libxml2 \
	nginx \
	samba \
	sudo \
	tar \
	unzip \
	wget && \

 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	php7 \
	php7-bz2 \
	php7-common \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-exif \
	php7-fpm \
	php7-ftp \
	php7-gd \
	php7-gmp \
	php7-iconv \
	php7-imap \
	php7-intl \
	php7-json \
	php7-ldap \
	php7-mcrypt \
	php7-openssl \
	php7-pcntl \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-pgsql \
	php7-posix \
	php7-session \
	php7-sqlite3 \
	php7-xml \
	php7-xmlreader \
	php7-zip \
	php7-zlib && \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	php7-apcu \
	php7-memcached && \

# fetch php smbclient source
 git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \

# uninstall build-dependencies
 apk del --purge \
	build-dependencies \
	build-dependencies2 && \

# cleanup
 rm -rf \
	/tmp/*

# ports and volumes
EXPOSE 443
VOLUME /config /data
