#!/bin/bash

USER_LIST="deploy@x.com"

/etc/init.d/nginx configtest > /dev/null
if [ $? -eq 1 ];then
	/root/scripts/nginx_rsync/mail.sh $USER_LIST	"${HOSTNAME} 配置异常" "${HOSTNAME} 配置异常"
else
	echo "$HOSTNAME Nginx Restart"
	/etc/init.d/nginx restart
fi
