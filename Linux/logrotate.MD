# 何为logrotate
```
logrotate 是一个 linux 系统日志的管理工具。可以对单个日志文件或者某个目录下的文件按时间 / 大小进行切割，压缩操作；
指定日志保存数量；还可以在切割之后运行自定义命令。
```

# 如何logrotate
```
logrotate 是基于 crontab 运行的，所以这个时间点是由 crontab 控制的，具体可以查询 crontab 的配置文件 /etc/anacrontab。 
系统会按照计划的频率运行 logrotate，通常是每天。在大多数的 Linux 发行版本上，计划每天运行的脚本位于 /etc/cron.daily/logrotate。

```
## 配置logrotate
```
执行文件： /usr/sbin/logrotate
主配置文件: /etc/logrotate.conf
自定义配置文件: /etc/logrotate.d/*.conf

修改配置文件后，并不需要重启服务。
由于 logrotate 实际上只是一个可执行文件，不是以 daemon 运行。
```

* 系统自带 cron task：/etc/cron.daily/logrotate，每天运行一次
```
cat /etc/cron.daily/logrotate

#!/bin/sh

/usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
exit 0
```

## 应用举例  /etc/logrotate.d/自定义配置
* /nginx 
`cat /etc/logrotate.d/nginx`
```
/data/logs/nginx/*.log {      
        daily      #每日切割
        missingok  #忽略执行过程中的所有错误
        rotate 7   #转储周期为7天，7天前的日志会被删除
        compress   #压缩
        notifempty #通常prerotate和postrotate脚本为每一个轮转的日志运行
        sharedscripts  #使所有的日志轮转完成后再执行脚本
        dateext    #时间戳，默认是年月日；可以使用dateformat参数自定义
        postrotate #定义日志切割完成后的操作，作用是重新定义进程日志文件描述符，是日志写入新的日志文件
                [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
        endscript
}
```
* /zabbix
```
/var/log/zabbix/zabbix_agentd.log {
    weekly
    rotate 12
    compress
    delaycompress
    missingok
    notifempty
    create 0664 zabbix zabbix
}
```

* /syslog
```
/var/log/cron
/var/log/maillog
/var/log/messages
/var/log/secure
/var/log/spooler
{
    missingok
    sharedscripts
    postrotate
    /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
    endscript
}
```
* /influxdb
```
/var/log/influxdb/influxd.log {
    daily
    rotate 7
    missingok
    dateext
    copytruncate
    compress
}
```

* corntab
``` 
#-#corntab
59 23 * * * /bin/bash /root/scripts/logrotate/logrotate
 
#--#cat /root/scripts/logrotate/logrotate
#!/bin/sh

/usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
exit 0
```

* logrotate.conf
```
weekly
rotate 4
create
dateext
include /etc/logrotate.d          
/var/log/wtmp {
    monthly
    create 0664 root utmp
	minsize 1M
    rotate 1
}

/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 1
}
```

* test
```
logrotate -d -f /etc/logrotate.d/nginx
```
