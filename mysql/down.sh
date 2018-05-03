#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

docker stop ali-mysql-server
docker rm ali-mysql-server
docker rmi leete/ali-mysql-server

docker build -t leete/ali-mysql-server .
# exit 0
# docker run -ti --name ali-mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d leete/ali-mysql-server
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data --restart always leete/ali-mysql-server \
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data leete/ali-mysql-server \
docker run -ti --name ali-mysql-server -p 3306:3306 -d --restart always leete/ali-mysql-server
# mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data

sleep 3
docker exec -ti ali-mysql-server bash ./down.sh
docker exec -tid ali-mysql-server \
mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data

sleep 3

docker exec -ti ali-mysql-server mysql_upgrade -u root
docker exec -ti ali-mysql-server mysql -e "grant all privileges on *.* to 'root'@'%';flush privileges;"
# RUN echo "mysql -e \"grant all privileges on *.* to 'root'@'localhost';\"" >> /root/start.sh

# echo "finished ok!"
