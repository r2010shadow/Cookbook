[Flink](
https://flink.apache.org/zh/usecases.html)

* get
```
wget  http://mirror.bit.edu.cn/apache/flink/flink-1.8.0/flink-1.8.0-bin-scala_2.12.tgz
```


* set
```
cat >> /etc/profile <<EOF 
# flink
export FLINK_HOME=/home/app/flink-1.8.0
export PATH=$FLINK_HOME/bin:$PATH
EOF
source /etc/profile
```

* run
```
./bin/start-cluster.sh
```

* test
```
yum -y install nmap-ncat  # for centos7
nc -l 9000
./bin/flink run examples/streaming/SocketWindowWordCount.jar --port 9000
https://ci.apache.org/projects/flink/flink-docs-release-1.8/tutorials/local_setup.html
http://10.10.9.109:8081/#/overview

  nc -l 9000   #stream test
lorem ipsum
ipsum ipsum ipsum
bye

  tailf /home/app/flink-1.8.0/log/flink-root-taskexecutor-0-master-9-109.out
lorem : 1
ipsum : 1
ipsum : 3
bye : 1 
```


