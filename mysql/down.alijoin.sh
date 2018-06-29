#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

PACKAGE_URL="http://rdsbak-hzi-v2.oss-cn-hangzhou-i.aliyuncs.com/custins2430373/hins4466495_data_20180628132643.tar.gz?OSSAccessKeyId=LTAITfQ7krsrEwRn&Expires=1530257504&Signature=H3x5U8asI5j8MB%2F5tgVhVKgbkMM%3D"

echo '++++++++++++++++'
echo ${PACKAGE_URL}
docker stop ali-join-server
docker rm ali-join-server

rm -rf /var/alijoin

# docker build --no-cache \
docker build \
--build-arg RDS=alijoin \
--build-arg PACKAGE_URL=${PACKAGE_URL} \
-t ali-join-server .

# exit 0
# docker run -ti --name ali-mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d leete/ali-mysql-server
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data --restart always leete/ali-mysql-server \
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data leete/ali-mysql-server \
docker run -ti --name ali-join-server -p 3307:3306 \
-v /var/alijoin:/home/mysql/data \
-d --restart always ali-join-server
# mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data

sleep 3
# mysqld_safe最后增加了开启事件
docker exec -ti ali-join-server bash ./down.sh
docker exec -tid ali-join-server \
mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data --event_scheduler=ON

sleep 3

docker exec -ti ali-join-server mysql_upgrade -u root
docker exec -ti ali-join-server mysql -e "grant all privileges on *.* to 'root'@'%';flush privileges;"
# root远程可链接
# docker exec -ti ali-join-server mysql -e "update user set host = '%' where user = 'root';flush privileges;"
# 新增两个帐号
# docker exec -ti ali-join-server mysql -e "insert into mysql.user(Host,User,Password) values("%","alimatch",password("123456"));"
# docker exec -ti ali-join-server mysql -e "insert into mysql.user(Host,User,Password) values("%","devuser",password("123456"));"
# 开启事件
docker exec -ti ali-join-server mysql -e "set global event_scheduler =1;"
# RUN echo "mysql -e \"grant all privileges on *.* to 'root'@'localhost';\"" >> /root/start.sh

# echo "finished ok!"
