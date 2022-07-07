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




