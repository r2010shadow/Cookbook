## 下载与配置
```
cd /usr/local/src/
wget -c https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.1.zip
wget -c https://artifacts.elastic.co/downloads/kibana/kibana-6.1.1-linux-x86_64.tar.gz
wget -c https://artifacts.elastic.co/downloads/logstash/logstash-6.1.1.tar.gz

tar -xf kibana-6.1.1-linux-x86_64.tar.gz -C /usr/local/src/
tar -xf logstash-6.1.1.tar.gz -C /usr/local/src/
unzip elasticsearch-6.1.1.zip -d /usr/local/src/
```
### 创建软连接
```
ln -sv /usr/local/src/logstash-6.1.1 /usr/local/logstash
ln -sv /usr/local/src/kibana-6.1.1-linux-x86_64/ /usr/local/kibana
ln -sv /usr/local/src/elasticsearch-6.1.1/ /usr/local/elasticsearch

vim /etc/profile.d/els.sh
# 内容如下
PATH=$PATH:/usr/local/elasticsearch/bin/
PATH=$PATH:/usr/local/kibana/bin/
PATH=$PATH:/usr/local/logstash/bin/
#
source /etc/profile.d/els.sh
```
## 配置elasticsearch需要的系统配置
```
ulimit -n 65536
vim /etc/security/limits.conf
#limits.conf内容如下
* soft nofile 65536
* hard nofile 65536
```
## ELK安装X-pack扩展(可选)
```
logstash-plugin install x-pack
elasticsearch-plugin install -xpack
kibana-plugin install x-pack
设置ELK栈的密码
/usr/local/elasticsearch/bin/x-pack/setup-passwords interactive
```
## 配置nginx的日志格式与日志路径
```

log_format main '{"@timestamp":"$time_iso8601",'
    '"host":"$server_addr",'
    ' "clientip" : "$remote_addr",'
    ' "size" : "$body_bytes_sent" ,'
    '"respnsetime":"$request_time",'
    '"upstremtime":"$upstream_response_time",'
    '"upstremhost":"$upstream_addr",'
    '"httphost":"$host",'
    '"referer":"$http_referer",'
    '"xff":"$http_x_forwarded_for",'
    '"agent":"$http_user_agent",'
    '"clientip":"$remote_addr",'
    '"request":"$request",'
    '"uri":"$uri",'
    '"status":"$status"}';
access_log /var/logs/nginx/access.log main;
error_log /var/logs/nginx/error.log error;
```
## 写Logstash的日志收集文件
```
input {
   file {
        type => "nginx-error-log"
        path => "/usr/local/openresty/nginx/logs/error.log"
    }
    file {
        type => "nginx-access-log"
        path => "/usr/local/openresty/nginx/logs/access.log"
        codec => json
    }
}

filter {

    if [type] =~ "nginx-error-log" 
    {

        grok {
            match => {
                "message" => "(?<datetime>\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}) \[(?<errtype>\w+)\] \S+: \*\d+ (?<errmsg>[^,]+), (?<errinfo>.*$)"
            }
        }

        mutate {
            rename => {
                "message" => "z_message" 
                "host" => "fromhost"
            } 
        }   
    } else if [type] =~ "nginx-access-log"  {
        mutate {
            split => {"upstremtime" => ","}
        }
        mutate {
            convert => { "upstremtime" => "float"}
        }
    }

    if [errinfo]
    {
            ruby {
                code => "
                        new_event = LogStash::Event.new(Hash[event.get('errinfo').split(', ').map{ |l| l.split(': ')  }])
                        new_event.remove('@timestamp')
                        event.append(new_event)
                "
            }

            grok {
                match => {
                    "request" => '"%{WORD:verb} %{URIPATHPARAM:urlpathparam}?(?: HTTP/%{NUMBER:httpversion})"'
                }
                patterns_dir => ["/home/data/logstash/patterns/"]
                #patterns_dir => ["/usr/local/logstash/vendor/bundle/jruby/2.3.0/gems/logstash-patterns-core-4.1.2/patterns/"]
                remove_field => [ "errinfo","request" ]
            }


     }
}

output {
    #elasticsearch { host => localhost }
    stdout { codec => rubydebug }
    if [type] =~ "nginx-error-log" {
        #redis{
        #    data_type => "channel"
        #   key => "logstash-nginx-%{+yyyy.MM.dd}"
        #}
        elasticsearch {
            hosts => [  "${ELASTIC_HOST:'http://127.0.0.1:9200'}"]
            index => "logstash-nginx-error-log-%{+YYYY.MM.dd}"
            document_type => "data"
            user => "xxx"
            password => "xxx"
        }      
    }else if [type] =~ "nginx-access-log"  {
          elasticsearch {
            hosts => [  "${ELASTIC_HOST:'http://127.0.0.1:9200'}"]
            index => "logstash-nginx-access-log-%{+YYYY.MM.dd}"
            document_type => "data"
            user => "xxx"
            password => "xxx"
        }      
    }

}
可以命名为logstash.conf
```
## 如部署到服务器，可使用FTP,scp,rsync,ansible等等工具上传到服务器(可选)

## 运行logstash进行测试，测试前，因为我们的logstash文件有使用到环境变量ELASTIC_HOST，主机地址可以自己进行定义。
```
export ELASTIC_HOST=[某服务器地址]

logstash -f -t logstash.conf ##检查配置是否正确
logstash -f logstash.conf ## 运行logstash
```
## 如果想以服务方式运行logstash
```

cd /usr/local/logstash/bin/

./system-install --help
Usage: system-install [OPTIONSFILE] [STARTUPTYPE] [VERSION]
NOTE: These arguments are ordered, and co-dependent

OPTIONSFILE: Full path to a startup.options file
OPTIONSFILE is required if STARTUPTYPE is specified, but otherwise looks first
in /usr/local/logstash/config/startup.options and then /etc/logstash/startup.options

Last match wins
STARTUPTYPE: e.g. sysv, upstart, systemd, etc.
OPTIONSFILE is required to specify a STARTUPTYPE.
VERSION: The specified version of STARTUPTYPE to use. The default is usually
preferred here, so it can safely be omitted.

Both OPTIONSFILE & STARTUPTYPE are required to specify a VERSION.

cd /etc/systemd/system/
vim logstash.service

### 定义变量的行
Environment="KEY=VALUE"
ExecStart=/usr/local/logstash/bin/logstash "--path.settings" "/usr/share/logstash/config" ###修改服务执行脚本
```
## 添加系统的Logstash用户
```

useradd -s /sbin/nologin -M logstash
chown -R logstash.logstash /usr/local/logstash ## 改变logstash的属主属组，否则服务启动会报错。
```
## 启动logstash
```
systemctrl start logstash
journalctl -u logstash ## 查看logstash的日志

监控logstash,配置文件
cd /usr/local/logstash/config
xpack.monitoring.elasticsearch.url : "Elasticsearch服务器地址"
xpack.monitoring.elasticsearch.username: logstash_system
xpack.monitoring.elasticsearch.password: xxx
```
