#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

docker stop ali-php5.6-fpm
docker rm ali-php5.6-fpm
docker rmi leete/ali-php5.6-fpm

docker build -t leete/ali-php5.6-fpm .

docker run -ti --name ali-php5.6-fpm -p 8080:80 -p 8822:22  -d --restart always leete/ali-php5.6-fpm
