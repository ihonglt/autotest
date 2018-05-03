#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

docker stop ali-php5.6-fpm
docker rm ali-php5.6-fpm
docker rmi leete/ali-php5.6-fpm

docker build -t leete/ali-php5.6-fpm .

docker run -ti --name ali-php5.6-fpm \
-p 80:80 -p 443:443 \
-v /usr/local/www/include/:/home/include/ \
-v /usr/local/www/h5agency/:/home/h5agency/ \
-v /usr/local/www/AliOSS/:/home/AliOSS/ \
-v /usr/local/www/spserver/:/home/spserver/ \
-v /usr/local/www/dsmp/:/home/dsmp/ \
--restart always \
-d leete/ali-php5.6-fpm
