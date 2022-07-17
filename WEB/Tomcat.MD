# 何为 Tomcat 
```
Tomcat是Apache 软件基金会（Apache Software Foundation）的Jakarta 项目中的一个核心项目，由Apache、Sun 和其他一些公司及个人共同开发而成。
```



* Run
```
groupadd tomcat useradd -g tomcat -d /data/tomcat -s /bin/nologin tomcat

wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz tar -zxvf apache-tomcat-.tar.gz mv apache-tomcat-8.5.20/ tomcat chown -R tomcat.tomcat tomcat

start
sh /data/tomcat/bin/startup.sh

stop
sh /data/tomcat/bin/shutdown.sh
```

* systemd
```
cat > /etc/systemd/system/tomcat.service << EOF [Unit] Description=Apache Tomcat 8.x Web Application Container Wants=network.target After=network.target

[Service] Type=forking

Environment=JAVA_HOME=/opt/jdk1.8.0_131/jre Environment=CATALINA_PID=/data/tomcat/temp/tomcat.pid Environment=CATALINA_HOME=/data/tomcat Environment='CATALINA_OPTS=-Xms512M -Xmx1G -Djava.net.preferIPv4Stack=true' Environment='JAVA_OPTS=-Djava.awt.headless=true'

ExecStart=/data/tomcat/bin/startup.sh ExecStop=/data/tomcat/bin/shutdown.sh SuccessExitStatus=143

User=tomcat Group=tomcat UMask=0007 RestartSec=10 Restart=always

[Install] WantedBy=multi-user.target EOF

web manage
/data/tomcat/conf/tomcat-users.xml Place the following two lines just above the last line.

/data/tomcat/webapps/manager/META-INF/context.xml /data/tomcat/webapps/host-manager/META-INF/context.xml Change both files fellow this line allow="127.\d+.\d+.\d+|::1|0:0:0:0:0:0:0:1|.*" /> systemctl restart tomcat
```

* more
` https://www.itzgeek.com/how-tos/linux/centos-how-tos/install-apache-tomcat-8-on-centos-7-rhel-7.html `

* run war package
```
show case# git clone https://github.com/efsavage/hello-world-war.git cd hello-world-war && mvn package cp hello-world-war-1.0.0.war /data/tomcat/webapps

vim /data/tomcat/conf/server.xml

service tomcat restart

http://10.10.9.107:8080/hello-world-war-1.0.0
```
* docker-tomcat
```
mkdir -p /data/tomcat/webapps cat > /etc/timezone << EOF Asia/Shanghai EOF

docker run -d --name tomcat -p 8080:8080
-v /data/tomcat/webapps:/usr/local/tomcat/webapps
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro
-v /etc/timezone:/etc/timezone:ro
tomcat:7-jre7
```
