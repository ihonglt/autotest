#!/bin/bash

docker start ali-mysql-server
docker exec -tid ali-mysql-server \
mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data
