FROM php:5.6-fpm
LABEL maintainer="hong_lt@hotmail.com"

ENV TZ "Asia/Shanghai"

RUN set -x \
	&& apt-get update && apt-get install -y \
	nginx vim openssh-server \
	zlib1g-dev \
	&& apt-get purge -y --auto-remove

RUN pecl install memcache redis \
    && docker-php-ext-enable memcache redis

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:server123&*(" | chpasswd
RUN mkdir -p /var/run/sshd
# RUN /etc/init.d/ssh start

# ADD nginx/nginx.conf /etc/nginx/
ADD nginx/default /etc/nginx/sites-available/
RUN mkdir /etc/nginx/ssl
ADD nginx/ssl /etc/nginx/ssl

EXPOSE 80
WORKDIR /root

CMD php-fpm -D && nginx && /usr/sbin/sshd -D
