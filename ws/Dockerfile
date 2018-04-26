FROM php:7.0-cli
LABEL maintainer="hong_lt@hotmail.com"

RUN echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update

RUN apt-get install -y nginx

RUN pecl install swoole \
        && docker-php-ext-enable swoole

ADD nginx/nginx.conf /etc/nginx/
ADD nginx/default /etc/nginx/sites-enabled/
RUN mkdir /etc/nginx/ssl
ADD nginx/ssl /etc/nginx/ssl

RUN mkdir /home/dsmp

ADD start.sh /home
RUN chmod +x /home/start.sh

EXPOSE 443
WORKDIR /home
#CMD ["nginx", "start.h"]
CMD nginx && ./start.sh
