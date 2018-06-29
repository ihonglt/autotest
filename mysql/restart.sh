#!/bin/bash

# mysqld_safe最后增加了开启事件
docker start $1
docker exec -tid $1 \
mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data --event_scheduler=ON
