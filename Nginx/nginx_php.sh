#!/bin/sh
case "$1" in
start)
ulimit -SH 65535
ulimit -n 65535
ulimit -u 65535
/usr/local/php/sbin/php-fpm
/usr/local/nginx/sbin/nginx
echo . && echo 'nginx started.'
;;
stop)
kill `ps -ef |awk '($8 ~/nginx/){print $2}'`
killall php-fpm
echo . && echo 'nginx stopped.'
;;
restart)
echo . && echo "Restart nginx ......"
killall php-fpm
kill `ps -ef |awk '($8 ~/nginx/){print $2}'`
echo . && echo 'nginx stopped.'
sleep 3
ulimit -SH 65535
ulimit -n 65535
ulimit -u 65535
/usr/local/php/sbin/php-fpm
/usr/local/nginx/sbin/nginx
echo . && echo 'nginx started.'
;;
reload)
kill -HUP `cat /usr/local/nginx/logs/nginx.pid`
echo . && echo 'nginx reloaded.'
;;
test)
/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
;;
*)
echo "$0 start | stop | restart | reload | test"
;;
esac
