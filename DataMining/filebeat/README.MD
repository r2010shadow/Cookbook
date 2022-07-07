# filebeat cookbook
Filebeat is a lightweight shipper for forwarding and centralizing log data.

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

