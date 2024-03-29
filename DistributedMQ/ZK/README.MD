

## get
`wget http://mirrors.shu.edu.cn/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz`

## set
```
tar xzvf zookeeper-3.4.14.tar.gz -C /opt/
mv /opt/zookeeper-3.4.14 /opt/zookeeper && cd /opt/zookeeper
mkdir data && echo "1" > /data/myid      # "2" "3"
cp /conf/zoo_sample.cfg /conf/zoo.cfg

vim /conf/zoo.cfg
dataDir=/opt/zookeeper/data
server.1=master:2888:3888
server.2=node2:2888:3888
server.3=node3:2888:3888

$ sudo /sbin/iptables -I INPUT -p tcp --dport 2181 -j ACCEPT
$ sudo /sbin/iptables -I INPUT -p tcp --dport 2888 -j ACCEPT
$ sudo /sbin/iptables -I INPUT -p tcp --dport 3888 -j ACCEPT
$ sudo /etc/rc.d/init.d/iptables save
$ sudo /etc/init.d/iptables restart

##run
/opt/zookeeper/bin/zkServer.sh start  

##test
zkServer.sh status
./zkCli.sh -server master:2181   # localhost -> ./zkCli.sh master:2181


#zkui  
https://github.com/DeemOpen/zkui
##get 
clone https://github.com/DeemOpen/zkui.git
wget http://mirrors.linuxeye.com/jdk/jdk-7u80-linux-x64.tar.gz
wget http://mirror.bit.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz


##set
cat >> /etc/profile << EOF
-#- java
export JAVA_HOME=/opt/jdk-7u80
export JRE_HOME=${JAVA_HOME}/jre
PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin
-#- maven
export M2_HOME=/opt/maven/
PATH=${PATH}:${M2_HOME}/bin
EOF
source /etc/profile && java -version && mvn -v

cd /opt/zkui
mvn clean install

vim config.cfg
zkServer=master:2181,node1:2181,node2:2181

cp config.cfg target/ 

##run
nohup java -jar target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar &

cat >> zkui-run.sh << EOF
#!/usr/bin/env bash
home=/opt/zkui

case $1 in
start)
nohup java -jar $home/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar &
[ $? -eq 0 ] && echo "OK:Runing.." || echo "Error:Run failed."
;;
stop)
kill -9 `ps -ef | grep zkui | grep -v grep | awk -c '{print $2}'`
[ $? -eq 0 ] && echo "OK:Stop." || echo "Error:Stop failed."
;;
*)
echo -e "\033[32mUsage: $0 [start|stop]\033[0m"
exit 1
;;
esac
EOF

##test
http://10.10.9.109:9090
```
