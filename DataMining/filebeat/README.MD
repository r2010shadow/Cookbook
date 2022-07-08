# filebeat cookbook
```
Filebeat is a lightweight shipper for forwarding and centralizing log data.
```
[Filebeat Reference](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)

## Get
```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.3.1-linux-x86_64.tar.gz
tar xzvf filebeat-8.3.1-linux-x86_64.tar.gz
```

## Case.nginx
* 1 fb-nginx.conf
```
...
log_format json '{ "time_local": "$time_local", '
                      '"remote_addr": "$remote_addr", '
                      '"referer": "$http_referer", '
                      '"request": "$request", '
                      '"status": $status, '
                      '"bytes": $body_bytes_sent, '
                      '"agent": "$http_user_agent", '
                      '"x_forwarded": "$http_x_forwarded_for", '
                      '"up_addr": "$upstream_addr",'
                      '"up_host": "$upstream_http_host",'
                      '"upstream_time": "$upstream_response_time",'
                      '"request_time": "$request_time"'
'}';
    access_log /var/log/nginx/access.log json;
...
```


* 2 OUTPUT kafka
```
filebeat.inputs:
- type: log
  enabled: true

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /data/logs/nginx/access.log

#-------------------------- kafka output ------------------------------
output.kafka:
 enabled: true
 hosts: [ "10.10.9.109:9092","10.10.9.107:9092","10.10.9.119:9092" ]
 topic: elk
 partition.round_robin:
   reachable_only: false

 required_acks: 1
 compression: gzip
 max_message_bytes: 100000000

#================================ Logging =====================================

# Sets log level. The default log level is info.
# Available log levels are: error, warning, info, debug
logging.level: info
logging.to_files: true
logging.to_syslog: false
logging.files:
  path: /var/log/
  name: filebeat.log
  rotateeverybytes: 52428800
  keepfiles: 2
```

* 3 OUTPUT ES
```
# syslog
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/messages

output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["10.10.9.109:9200"]
  ```
  
* 4 RUN 
```
nohup ./bin/filebeat -f config/test.conf >>/FILEBEAT_HOME/logs/filebeat.log &
```
* 5 Troubleshooting
```
A、filebeat运行不成功

问题：配置文件格式有问题
使用filebeat.exe –c filebeat.yml 查看报错，也可以看filebeat路径下的log文件夹中的filebeat文件

B、 filebeat第一次运行成功无数据

问题：路径有问题,或运行条件设置有问题（例如只采集某个条件下的数据，文件中没有符合条件的数据，这种情况下先注释掉采集条件测试一下）

C、filebeat运行成功第一次运行后有数据，第二次无数据

问题：filebeat读取文件后会生成一个registry文件，注意windows机器中这个文件在手动启动的情况下会在filebeat安装目录下的data文件夹中，服务注册启动的情况下会在C盘下隐藏文件夹C:\ProgramData\filebeat中，删除掉这个就可以了

D、filebeat运行成功有数据，但是新添加数据不读取问题

问题：filebeat传输存在反压机制，在数据量特别大或者传输通道不通的情况下，filebeat会进行反压，暂停发送，等到数据量稳定或者数据传输通道正常的之后才会发送

```
