#!/bin/bash
#howto  /bin/bash /root/scripts/nginx_conf/sed.sh up 10.10.7.99 Pay01

CONFIG="/home/app/nginx/conf.d/upstream.config"
MAIL_LIST="helpdesk@x.com\;deploy@x.com\;"
LOG_FILE="/root/scripts/nginx_conf/release.log"
DATE_N=`date +%F\ %H:%M:%S`


up_conf () {
    /bin/sed -i  "s/\(.*\)#\(.*\)server $1\(.*\)$2/\1\2server $1\3$2/g" $CONFIG
}


down_conf () {
    /bin/sed -i "s/\(.*\)server $1\(.*\)$2/\t\t#server $1\2$2/g" $CONFIG
}



case $1 in
    up)
        up_conf $2 $3
	echo "$DATE_N $1 $2 $3" >> $LOG_FILE
    ;;
    down)
        down_conf $2 $3
	echo "$DATE_N $1 $2 $3" >> $LOG_FILE
    ;;
    nginx_reload)
	/etc/init.d/nginx reload
	echo "$DATE_N $1" >> $LOG_FILE
    ;;
    *)
        echo "(up|down|nginx_reload) IP  NAME"
    ;;
esac
