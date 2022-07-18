## 概念
```
   Broker：简单来说就是消息队列服务器实体。

　　Exchange：消息交换机，它指定消息按什么规则，路由到哪个队列。

　　Queue：消息队列载体，每个消息都会被投入到一个或多个队列。

　　Binding：绑定，它的作用就是把exchange和queue按照路由规则绑定起来。

　　Routing Key：路由关键字，exchange根据这个关键字进行消息投递。

　　vhost：虚拟主机，一个broker里可以开设多个vhost，用作不同用户的权限分离。

　　producer：消息生产者，就是投递消息的程序。

　　consumer：消息消费者，就是接受消息的程序。

　　channel：消息通道，在客户端的每个连接里，可建立多个channel，每个channel代表一个会话任务。

消息队列的使用过程，如下：

（1）客户端连接到消息队列服务器，打开一个channel。

（2）客户端声明一个exchange，并设置相关属性。

（3）客户端声明一个queue，并设置相关属性。

（4）客户端使用routing key，在exchange和queue之间建立好绑定关系。

（5）客户端投递消息到exchange。

exchange接收到消息后，就根据消息的key和已经设置的binding，进行消息路由，将消息投递到一个或多个队列里。
```
* Get
```
#centos 
yum install make gcc gcc-c++ m4 ncurses-devel openssl-devel unixODBC-devel -y
yum install perl -y
cd opt && wget http://erlang.org/download/otp_src_22.3.tar.gz .
wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.3/rabbitmq-server-generic-unix-3.8.3.tar.xz .

#erl
tar xzf otp_src_22.3.tar.gz
mkdir /usr/local/erlang
cd otp_src_22.3
./configure --prefix=/usr/local/erlang
make && make install

#mq
tar xvJf rabbitmq-server-generic-unix-3.8.3.tar.xz
mkdir /usr/local/rabbitmq
mv rabbitmq_server-3.8.3/* /usr/local/rabbitmq

# profile
vi /etc/profile
export PATH=$PATH:/usr/local/erlang/bin
export PATH=$PATH:/usr/local/rabbitmq/sbin
source /etc/profile
erl -version 
```


* Set
```
cd /usr/local/rabbitmq/sbin/
#start.sh
export PATH=$PATH:/usr/local/erlang/bin
export PATH=$PATH:/usr/local/rabbitmq/sbin
/usr/local/rabbitmq/sbin/./rabbitmq-server -detached

#stop.sh
export PATH=$PATH:/usr/local/erlang/bin
export PATH=$PATH:/usr/local/rabbitmq/sbin
/usr/local/rabbitmq/sbin/./rabbitmqctl stop

chmod +x st*

cd /usr/lib/systemd/system/
 cat rabbitmq.service
[Unit]
Description=rabbitmq-server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/usr/local/rabbitmq/sbin/start.sh
ExecStop=/usr/local/rabbitmq/sbin/stop.sh
PrivateTmp=true
[Install]
WantedBy=multi-user.target

ln -s `pwd`/rabbitmq.service /etc/systemd/system/multi-user.target.wants
systemctl daemon-reload
systemctl enable rabbitmq.service
systemctl start rabbitmq # 开启
systemctl  stop rabbitmq # 关闭
systemctl status rabbitmq  # 查看状态
```

* WEB & PASSWORD
```
##  开启web管理页面
rabbitmq-plugins enable rabbitmq_management
rabbitmq-server start &
rabbitmqctl stop
##

rabbitmqctl add_user USERNAME   PASSWORD
rabbitmqctl set_user_tags USERNAME administrator
rabbitmqctl set_permissions -p / USERNAME ".*" ".*" ".*"
rabbitmqctl list_user_permissions USERNAME
rabbitmqctl list_users
# 重置密码
rabbitmqctl change_password  USERNAME   PASSWORD
```






