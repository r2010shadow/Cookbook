#!/bin/bash


tday=`date +%Y%m%d`

tar -C /home/app/ -zcf /data/backup/$HOSTNAME/nginx/nginx_conf_$tday.tar.gz nginx

find /data/backup/$HOSTNAME/* -mtime +7  -exec rm -rf {} \;
