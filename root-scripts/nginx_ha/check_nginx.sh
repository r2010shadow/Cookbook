#!/bin/bash
if [ "$(ps -ef | grep "nginx: master process"| grep -v grep )" == "" ]
then
	/etc/init.d/nginx start
 	sleep 5
 	if [ "$(ps -ef | grep "nginx: master process"| grep -v grep )" == "" ]
 	then
 	killall keepalived
 	fi
fi
