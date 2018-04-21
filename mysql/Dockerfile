FROM mysql:5.6
LABEL maintainer="hong_lt@hotmail.com"

#RUN echo "Asia/Shanghai" > /etc/timezone
ENV TZ "Asia/Shanghai"

ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

ENV PACKAGE_URL http://rdsbak-hzi-v2.oss-cn-hangzhou-i.aliyuncs.com/custins4888969/hins4087993_data_20180421151645.tar.gz?OSSAccessKeyId=LTAITfQ7krsrEwRn&Expires=1524386165&Signature=CF0V2EaWWnuOhvg1ck0fYr5b%2B7A%3D

# RUN apt-get update
# RUN apt-get install -y net-tools
# RUN apt-get install -y openssh-server
# RUN echo "root:server123&*(" | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN /etc/init.d/ssh start

# RUN echo "mysql-server mysql-server/root_password password 123456" | debconf-set-selections
# RUN echo "mysql-server mysql-server/root_password_again password 123456" | debconf-set-selections
# RUN apt-get install -y mysql-server
# RUN /etc/init.d/mysql start \
#     # && mysql_upgrade -u root \
#     && mysql -e "grant all privileges on *.* to 'root'@'%';flush privileges;" \
#     && mysql -e "grant all privileges on *.* to 'root'@'localhost';"

# RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# #RUN wget http://oss.aliyuncs.com/aliyunecs/rds_backup_extract.sh
# RUN apt install percona-xtrabackup -y

RUN set -x \
	&& apt-get update && apt-get install -y \
    libdbd-mysql-perl rsync libcurl3 libev4 wget && rm -rf /var/lib/apt/lists/* \
	&& wget "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/debian/stretch/x86_64/percona-xtrabackup-24_2.4.8-1.stretch_amd64.deb" \
    && dpkg -i percona-xtrabackup-24_2.4.8-1.stretch_amd64.deb \
    && apt-get purge -y --auto-remove #ca-certificates wget

RUN mkdir /home/mysql
RUN mkdir /home/mysql/data

#RUN echo "#!/bin/bash" > /root/start.sh 
#RUN echo "/usr/sbin/sshd -D" >> /root/start.sh
#RUN echo "/usr/bin/mysqld_safe" >> /root/start.sh 

# WORKDIR /root
# RUN cd /root
ADD http://oss.aliyuncs.com/aliyunecs/rds_backup_extract.sh /root
# RUN chmod +x /root/rds_backup_extract.sh

RUN echo "#!/bin/bash" > /root/down.sh
RUN echo "wget -c \"$PACKAGE_URL\" -O /root/alimargin.tar.gz" >> /root/down.sh
RUN echo "bash rds_backup_extract.sh -f /root/alimargin.tar.gz -C /home/mysql/data" >> /root/down.sh
RUN echo "innobackupex --defaults-file=/home/mysql/data/backup-my.cnf --apply-log /home/mysql/data" >> /root/down.sh

# RUN groupadd mysql
# RUN useradd -g mysql -s /sbin/nologin mysql

RUN echo "sed -i 's/innodb_fast_checksum/#&/g' /home/mysql/data/backup-my.cnf" >> /root/down.sh
RUN echo "sed -i 's/innodb_page_size/#&/g' /home/mysql/data/backup-my.cnf" >> /root/down.sh
RUN echo "sed -i 's/innodb_log_block_size/#&/g' /home/mysql/data/backup-my.cnf" >> /root/down.sh
RUN echo "sed -i 's/innodb_log_checksum_algorithm/#&/g' /home/mysql/data/backup-my.cnf" >> /root/down.sh
RUN echo "sed -i 's/rds_encrypt_data/#&/g' /home/mysql/data/backup-my.cnf" >> /root/down.sh
RUN echo "sed -i 's/innodb_encrypt_algorithm/#&/g' /home/mysql/data/backup-my.cnf" >> /root/down.sh

RUN echo "chown -R mysql:mysql /home/mysql/data" >> /root/down.sh

# RUN echo "mysqld_safe --defaults-file=/home/mysql/data/backup-my.cnf --user=mysql --datadir=/home/mysql/data &" >> /root/start.sh
# RUN echo "sleep 3" >> /root/start.sh
# RUN echo "mysql_upgrade -u root" >> /root/start.sh
# RUN echo "mysql -e \"grant all privileges on *.* to 'root'@'%';flush privileges;\"" >> /root/start.sh
# RUN echo "mysql -e \"grant all privileges on *.* to 'root'@'localhost';\"" >> /root/start.sh

# RUN chmod +x /root/start.sh

EXPOSE 22
EXPOSE 3306
WORKDIR /root

#ENTRYPOINT ./start.sh
# ENTRYPOINT ["mysqld_safe", "--defaults-file=/home/mysql/data/backup-my.cnf", "--user=mysql", "--datadir=/home/mysql/data"]
# CMD ["mysqld_safe", "--defaults-file=/home/mysql/data/backup-my.cnf", "--user=mysql", "--datadir=/home/mysql/data"]
CMD /bin/bash
