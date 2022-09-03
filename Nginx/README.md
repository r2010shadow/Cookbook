# Nginx 

## 日常维护
- 默认启动
/usr/local/nginx/sbin/nginx

- 指定配置文件
/usr/local/nginx/sbin/nginx -c /tmp/nginx.conf

- 指定安装目录
/usr/local/nginx/sbin/nginx -p /usr/local/nginx/

- 指定全局配置项  把pid写入指定文件 
/usr/local/nginx/sbin/nginx -g "pid /var/nginx/test.pid;"

- -g的约束 需写完整
/usr/local/nginx/sbin/nginx -g "pid /var/nginx/test.pid;" -s stop

### 停止服务
```
/usr/local/nginx/sbin/nginx -s stop
kill -s SIGTERM <master process pid>

完成全部请求后停止服务 优雅方式
/usr/local/nginx/sbin/nginx -s quit
kill -s SIGQUIT <master process pid> 
kill -s SIGQUIT <worker process pid>
```

- 测试
/usr/local/nginx/sbin/nginx -t

- 重载
/usr/local/nginx/sbin/nginx -s reload

- 日志文件回滚  日志转移备份，并打开新的日志，避免过大
/usr/local/nginx/sbin/nginx -s reopen

## 平滑升级 
```
1. 替换二进制文件nginx

2. kill -s SIGUSR2 <master process pid>

此时nginx.pid被重命名nginx.pid.oldbin

root@node-8-62:~$ls /run/nginx*

/run/nginx.pid  /run/nginx.pid.oldbin

3. 启动新版本的nginx 优雅方式关闭旧的nginx 

kill -s SIGQUIT <master process pid> 
```

- master
1个管理多个worker

- worker
1对1 对应CPU核心数量

## 负载均衡的基本配置
```
nginx处理静态，优于动态并转发上游tomcat/apache

upstream name {...}    块名

    ip_hash;   为请求指定唯一上游服务器，不与weight同用，上游失效则标记down

    server 名字可以是域名、IP地址端口、UNIX句柄等 weight backup max_fails
```
     

## 反向代理的基本配置
```
proxy_pass URL;    URL是主机名、IP:port、upstream块名

proxy_method method;    转发时的协议方法名，如POST、GET
```
    

## Nginx服务的基本配置
```
-用于调试进程和定位问题的配置项

daemon on | off    off不在后台运行，调试目的跟踪nginx并显示日志；

master_process on | off    off下master自身来处理请求，而不会fork除worker子进程；

error_log  依次增大，开启后其后的都会输出; debug/info/notice/warn/error/crit/alert/emerg

-正常运行的配置项

env VAR|VAR = VALUE    定义环境变量；

include /path/file;    嵌入其他配置文件；

pid path/file;    master进行ID的pid文件存放路径；

user username [groupname]；    worker进行运行的用户及用户组；

worker_rlimit_nofile limit;    指定worker进行可以打开的最大文件句柄数；

-性能优化的配置项

worker_process 1;    worker进程个数，若多于内核数则争抢带来切换产生的消耗；

worker_cpu_affinity cpumask[cpumask...]    绑定worker进程到指定CPU内核；

worker_priority nice；    配置优先级由高到低，-20到+19；一般为-5到+5

-事件类配置项

accept_mutex [on|off];    负载均衡锁，关闭后TCP连接耗时缩短，但worker进程间不平衡；

worker_connections number;    每个worker同时处理的最大连接数；

HTTP核心模块

虚拟主机与请求分发

listen    一个IP对应多个主机域名

server_name    按顺序完全匹配、通配符在前的匹配、通配符在后面的匹配、正则匹配；

都不匹配则去server块中寻找；

location    众多匹配中只有第一个被处理
    =    把URL作为字符串
    ~    字母大小写敏感
    ~*    忽略字母大小写
    ^~    前部匹配，已XX开头的都匹配
    @    内部重定向
    /    匹配所有请求，若前面都不匹配，用其收底

文件路径

root path   完整url来映射

    location /download/{ root /opt/web/html/;}

    若请求/download/index/test.html返回 /opt/web/html/dowload/index/test.html

alias path    只能放在location块中使用

    location /conf { alias /usr/local/nginx/conf/; }

    若请求/conf/nginx.conf返回 /usr/local/nginx/conf/nginx.conf

index   访问首页

    path /index.php

error_page 根据HTTP返回码重定向页面

    error_page 404 =200 /empty.git;  通过'='更改返回错误码

    location / ( error_page 404 @fallback; ）    重定向到另一个location来处理

    location @fallback (proxy_pass http://backend;)


内存及磁盘资源的分配

client_body_in_file_only off|on|clean;    HTTP包体只存储到磁盘文件中

client_body_in_single_buffer off|on;      HTTP包体尽量写入到内存buffer中
```

### 内核优化
```
/etc/sysctl.conf

fs.file-max = 999999                                                #最大并发数

net.ipv4.tcp_syncookies = 1                        #与性能无关，解决SYN攻击

net.ipv4.tcp_tw_reuse = 1                  #timewait状态的socket重新用于tcp连接

net.ipv4.tcp_keepalive_time = 600

net.ipv4.tcp_fin_timeout = 30

net.ipv4.tcp_max_tw_buckets = 5000        #允许timewait数量的最大值

net.ipv4.ip_local_port_range = 1024 61000

net.ipv4.tcp_rmem = 4096 327684 262142    #TCP接收缓存
net.ipv4.tcp_wmem = 4096 327684 262142   #TCP发送缓存

net.core.netdev_max_backlog = 8096

net.core.wmem_default = 262144
net.core.rmem_default = 262144

net.core.rmem_max = 2097152
net.core.wmem_max = 2097152

net.ipv4.tcp_max_syn_backlog = 1024      #接收syn请求的最大长度



严格的模块先后顺序， 否则将不能工作。

ngx_modules.c

```
