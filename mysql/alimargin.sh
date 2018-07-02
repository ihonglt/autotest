#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

RDS="alimargin"
PACKAGE_URL="http://rdsbak-hzi-v2.oss-cn-hangzhou-i.aliyuncs.com/custins4888969/hins4498759_data_20180629154147.tar.gz?OSSAccessKeyId=LTAITfQ7krsrEwRn&Expires=1530453096&Signature=Bp%2Biyw%2BrmflEHuc5KXTf%2Fodj56w%3D"
docker stop $RDS-server
docker rm $RDS-server

rm -rf /var/$RDS

echo "#!/bin/bash" > start.sh
echo "wget -c \"$PACKAGE_URL\" -O /root/$RDS.tar.gz" >> start.sh
echo "bash rds_backup_extract.sh -f /root/$RDS.tar.gz -C /home/mysql/data" >> start.sh
echo "rm /root/$RDS.tar.gz" >> start.sh
echo "innobackupex --defaults-file=/home/mysql/data/backup-my.cnf --apply-log /home/mysql/data" >> start.sh

# RUN groupadd mysql
# RUN useradd -g mysql -s /sbin/nologin mysql

echo "sed -i 's/innodb_fast_checksum/#&/g' /home/mysql/data/backup-my.cnf" >> start.sh
echo "sed -i 's/innodb_page_size/#&/g' /home/mysql/data/backup-my.cnf" >> start.sh
echo "sed -i 's/innodb_log_block_size/#&/g' /home/mysql/data/backup-my.cnf" >> start.sh
echo "sed -i 's/innodb_log_checksum_algorithm/#&/g' /home/mysql/data/backup-my.cnf" >> start.sh
echo "sed -i 's/rds_encrypt_data/#&/g' /home/mysql/data/backup-my.cnf" >> start.sh
echo "sed -i 's/innodb_encrypt_algorithm/#&/g' /home/mysql/data/backup-my.cnf" >> start.sh

echo "chown -R mysql:mysql /home/mysql/data" >> start.sh

# exit 0
# docker run -ti --name ali-mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d leete/ali-mysql-server
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data --restart always leete/ali-mysql-server \
# docker run -ti --name ali-mysql-server -p 3306:3306 -d -v /var/mysql/data:/home/mysql/data leete/ali-mysql-server \
docker run -ti --name $RDS-server -p 3306:3306 \
-v /var/$RDS:/home/mysql/data \
-d --restart always $RDS-server
# mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data

sleep 3
docker cp start.sh $RDS-server:/root/down.sh
rm start.sh

# mysqld_safe最后增加了开启事�?
docker exec -ti $RDS-server bash ./down.sh
docker exec -tid $RDS-server \
mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data --event_scheduler=ON

sleep 3

docker exec -ti $RDS-server mysql_upgrade -u root
docker exec -ti $RDS-server mysql -e "grant all privileges on *.* to 'root'@'%';flush privileges;"
# root远程可链�?
# docker exec -ti ali-margin-server mysql -e "update user set host = '%' where user = 'root';flush privileges;"
# 新增两个帐号
# docker exec -ti ali-margin-server mysql -e "insert into mysql.user(Host,User,Password) values("%","alimatch",password("123456"));"
# docker exec -ti ali-margin-server mysql -e "insert into mysql.user(Host,User,Password) values("%","devuser",password("123456"));"
# 开启事�?
docker exec -ti $RDS-server mysql -e "set global event_scheduler =1;"
# RUN echo "mysql -e \"grant all privileges on *.* to 'root'@'localhost';\"" >> /root/start.sh

# echo "finished ok!"
