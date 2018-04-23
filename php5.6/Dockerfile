FROM php:5.6-fpm
LABEL maintainer="hong_lt@hotmail.com"

ENV TZ "Asia/Shanghai"

RUN set -x \
	&& apt-get update && apt-get install -y \
	nginx vim openssh-server \
	&& apt-get purge -y --auto-remove

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:server123&*(" | chpasswd
RUN mkdir -p /var/run/sshd
# RUN /etc/init.d/ssh start

EXPOSE 80
WORKDIR /root
#CMD ["nginx", "start.h"]
# CMD nginx
CMD nginx && /usr/sbin/sshd -D
