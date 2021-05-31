# 原php包依赖于debian jessie
FROM php:7.0-fpm
MAINTAINER Jin<cpp@strcpy.cn>

ENV PORT 9000
ENV LICENSE BgNSXAIIDgR42fdRFV5NXVsYWk6896FeCkgECAgBTa908AgBFQMEGAYF1744A1FJBwgUBVE=

# 更新镜像源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY docker-file/sources.list.jessie /etc/apt/sources.list

# 安装包
RUN apt-get update \
    && apt-get install -y libmcrypt-dev libpng-dev libjpeg-dev libfreetype6-dev  libpng12-dev

# 安装php扩展
RUN pecl install -o -f redis &&  rm -rf /tmp/pear && docker-php-ext-enable redis

RUN docker-php-ext-configure gd --enable-gd-native-ttf \
--with-freetype-dir=/usr/include/freetype2 --with-png-dir=/usr/include --with-jpeg-dir=/usr/include

RUN docker-php-ext-install pdo pdo_mysql session sockets bcmath opcache calendar mcrypt hash mysqli gd

# 创建目录
RUN set -ex && mkdir -p /var/www/app /tmp/log /var/www/cache /var/run/php7-fpm

# 时区
RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# 设置工作目录
WORKDIR /var/www/app

# 设置目录权限
RUN chown -R www-data:www-data /tmp/log /var/www/cache /var/www/app /var/run/php7-fpm \
&& chmod -R +w /tmp/log /var/www/cache /var/www/app /var/run/php7-fpm

EXPOSE $PORT