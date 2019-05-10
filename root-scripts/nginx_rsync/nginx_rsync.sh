#!/bin/bash 

LB_VIP=10.10.x.100
LB_A=10.10.x.102
LB_B=10.10.x.103


/usr/sbin/ip addr|grep $LB_VIP	>/dev/null
if [ $? -eq 1 ];then
	exit 1
fi


ssh $LB_B "/usr/sbin/ip addr|grep $LB_VIP >/dev/null"
if [ $? -ne 1 ];then
	exit 1
fi

#nginx.conf
rsync -vzrtopg --progress --delete /home/app/nginx/nginx.conf $LB_B:/home/app/nginx/ >/dev/null
#conf.d
rsync -vzrtopg --progress --delete /home/app/nginx/conf.d/ $LB_B:/home/app/nginx/conf.d/ >/dev/null
#ssl
rsync -vzrtopg --progress --delete /home/app/nginx/ssl/ $LB_B:/home/app/nginx/ssl/ >/dev/null

sleep 2

ssh $LB_B "/root/scripts/nginx_rsync/nginx_check.sh"
