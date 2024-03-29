# Pinpoint
* pre
```
tom='/home/app/tomcat'
masterIP=10.10.9.109
spyIP=10.10.9.119
jdk
hbase 
zookeeper
```

* get
```
https://github.com/naver/pinpoint/releases/tag/1.7.3
  pinpoint
wget https://github.com/naver/pinpoint/releases/download/1.7.3/pinpoint-agent-1.7.3.tar.gz
wget https://github.com/naver/pinpoint/releases/download/1.7.3/pinpoint-collector-1.7.3.war
wget https://github.com/naver/pinpoint/releases/download/1.7.3/pinpoint-web-1.7.3.war
  tomcat
wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz
```

* set 
```
_SINGLE MODEL
create hbase tables
https://github.com/r2010shadow/pinpoint/blob/master/hbase/scripts/hbase-create.hbase
$hbase/bin/hbase shell hbase-create.hbase

tar xzf apache-tomcat-8.5.42.tar.gz -C /home/app/tomcat/
rm -rf /home/app/tomcat/webapps/*
mkdir /home/app/tomcat/webapps/ROOT
unzip pinpoint-collector-1.7.3.war.war -C /home/app/tomcat/
unzip pinpoint-web-1.7.3.war -C /home/app/tomcat/webapps/ROOT/

vim     #避免端口冲突
  /home/app/tomcat/conf/server.xml
sed -i 's/port="8005"/port="18005"/g' server.xml
sed -i 's/port="8080"/port="18080"/g' server.xml
sed -i 's/port="8443"/port="18443"/g' server.xml
sed -i 's/port="8009"/port="18009"/g' server.xml
sed -i 's/redirectPort="8443"/redirectPort="18443"/g' server.xml

~ pinpoint-collector
  $tom/webapps/WEB-INF/classes/pinpoint-collector.properties
cluster.enable=true
cluster.zookeeper.address=master,node1,node2
cluster.zookeeper.sessiontimeout=30000
cluster.listen.ip=0.0.0.0
cluster.listen.port=9997

  $tom/webapps/WEB-INF/classes/hbase.properties
hbase.client.host=master,node1,node2


~ pinpoint-web
  #tom/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
cluster.enable=true
cluster.web.tcp.port=9997
cluster.zookeeper.address=master,node1,node2
cluster.zookeeper.sessiontimeout=30000
cluster.zookeeper.retry.interval=60000
cluster.connect.address=$masterIP:9997         # collector IP

  #tom/webapps/ROOT/WEB-INF/classes/hbase.properties
hbase.client.host=master,node1,node2

~ pinpint-agent
  spy in other host
mkdir /home/app/pp-agent && tar xzf pinpoint-agent-1.7.3.tar.gz -C /home/app/pp-agent
  /home/app/pp-agent/pinpoint.config
profiler.collector.ip=$masterIP              # collector IP

  $tom/bin/catalina.sh
# pinpoint
CATALINA_OPTS="$CATALINA_OPTS -javaagent:/home/app/pp-agent/pinpoint-bootstrap-1.7.3.jar"      #spy here
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.agentId=test001"                                      
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.applicationName=$spyIP_Test_App"
```

* run 
`sh $tom/bin/catalina.sh start     # start master 、 spy host tomcat`



* test
`http://$masterIP:18080`



* more
```
agent默认收集20%的请求所以可能请求一次无法看到的。当然也可以配置全部收集。

#pinpoint-flink.jar    [存疑] 
mvn -N io.takari:maven:0.7.6:wrapper
./mvnw install -Dmaven.test.skip=true
flink run /opt/pinpoint/pinpoint/flink/target/pinpoint-flink-job-1.8.3-SNAPSHOT.jar
https://www.jianshu.com/p/aba6cc752f84
```
