#!/usr/bin/env bash

home=/home/app/filebeat-8.3.1
#confs=

case $1 in
start)
nohup /home/app/filebeat-8.3.1/filebeat -e -c /home/app/filebeat-8.3.1/filebeat.yml &
[ $? -eq 0 ] && echo "OK:Runing.." || echo "Error:Run failed."
;;
stop)
kill -9 `ps -ef | grep filebeat | grep -v grep | awk -c '{print $1}'`
[ $? -eq 0 ] && echo "OK:Stop." || echo "Error:Stop failed."
;;
*)
echo -e "\033[32mUsage: $0 [start|stop]\033[0m"
exit 1
;;
esac
