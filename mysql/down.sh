#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

docker stop $1-server
docker rm $1-server

docker build -t $1-server .
# exit 0
# docker run -ti --name ali-mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d leete/ali-mysql-server
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data --restart always leete/ali-mysql-server \
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data leete/ali-mysql-server \
docker run -ti --name $1-server -p 3306:3306 -v /var/mysql:/home/mysql/data \
-d --restart always $1-server
# mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data

# sleep 3
# # mysqld_safe最后增加了开启事件
# docker exec -ti ali-mysql-server bash ./down.sh
# docker exec -tid ali-mysql-server \
# mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data --event_scheduler=ON

# sleep 3

# docker exec -ti ali-mysql-server mysql_upgrade -u root
# docker exec -ti ali-mysql-server mysql -e "grant all privileges on *.* to 'root'@'%';flush privileges;"
# # root远程可链接
# docker exec -ti ali-mysql-server mysql -e "update user set host = '%' where user = 'root';flush privileges;"
# # 新增两个帐号
# docker exec -ti ali-mysql-server mysql -e "insert into mysql.user(Host,User,Password) values("%","alimatch",password("123456"));"
# docker exec -ti ali-mysql-server mysql -e "insert into mysql.user(Host,User,Password) values("%","devuser",password("123456"));"
# # 开启事件
# docker exec -ti ali-mysql-server mysql -e "set global event_scheduler =1;"
# # RUN echo "mysql -e \"grant all privileges on *.* to 'root'@'localhost';\"" >> /root/start.sh

# echo "finished ok!"
