#!/usr/bin/env bash

home=/home/app/logstash-8.3.1
confs=logstash-es.conf

case $1 in
start)
$home/bin/logstash -f $home/config/$confs &
[ $? -eq 0 ] && echo "OK:Runing.." || echo "Error:Run failed."
;;
stop)
kill -9 `ps -ef | grep logstash | grep -v grep | awk -c '{print $2}'`
[ $? -eq 0 ] && echo "OK:Stop." || echo "Error:Stop failed."
;;
*)
echo -e "\033[32mUsage: $0 [start|stop]\033[0m"
exit 1
;;
esac
