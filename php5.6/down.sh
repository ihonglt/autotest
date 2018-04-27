#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

docker stop ali-php5.6-fpm
docker rm ali-php5.6-fpm
docker rmi leete/ali-php5.6-fpm

docker build -t leete/ali-php5.6-fpm .

docker run -ti --name ali-php5.6-fpm \
-p 80:80 -p 443:443 \
-v /usr/local/api:/home/api \
-v /usr/local/dsmp:/home/dsmp \
--restart always \
-d leete/ali-php5.6-fpm
