# get
`https://download.elastic.co/elastic/sense/sense-latest.tar.gz`
 
# set
```
cat > /etc/security/limits.conf <<EOF
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
* soft nofile 65536
* hard nofile 65536
EOF

cat >> /etc/sysctl.conf <<EOF
vm.max_map_count=262144       #VMA(虚拟内存区域) numbers
vm.swappiness = 1             #close swap
EOF


sysctl -p

#java cloudbaidu/software/java
 cat >> /etc/profile << EOF
# java
JAVA_HOME=/opt/jdk1.8.0_131
JRE_HOME=/opt/jdk1.8.0_131/jre
PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/opt/jdk1.8.0_131/bin:/opt/jdk1.8.0_131/jre/bin:/opt/jdk1.8.0_131/bin:/opt/jdk1.8.0_131/jre/bin
EOF

source /etc/profile && java -version
##

useradd elasticsearch
tar xzvf el*.tar.gz
chown -R elasticsearch.elasticsearch elasticsearch-6.6.2
mkdir /data/es-data && chown -R elasticsearch.elasticsearch /data/es-data

#-# config for cluster 3
vim elasticsearch-6.6.2/config/elasticsearch.yml
cluster.name: es-cluster
node.name: master       @node1 -2
path.data: /data/es-data
network.host:10.10.9.109     @node1 -2
http.port: 9200
discovery.zen.ping.unicast.hosts: ["10.10.9.109","10.10.9.107","10.10.9.119"]
#-#


#run
su elasticsearch
./bin/elasticsearch -d
##


#test
# nodes
curl -XGET '10.10.9.109:9200/_cat/nodes?v'
# node indices
curl -XGET '10.10.9.109:9200/_cat/indices?v'


#- pre other 
https://www.kancloud.cn/devops-centos/centos-linux-devops/397454
#-

#- Elasticsearch: 权威指南  https://www.elastic.co/guide/cn/elasticsearch/guide/current/_add_failover.html
                           https://fuxiaopang.gitbooks.io/learnelasticsearch/data/partial_update.html

## Try
#case 1
PUT /website/blog/123
{
  "title": "My first blog entry",
  "text":  "Just trying this out...",
  "date":  "2014/01/01"
}

curl -i -XGET http://10.10.9.109:9200/website/blog/123?pretty
HTTP/1.1 200 OK
content-type: application/json; charset=UTF-8
content-length: 264

{
  "_index" : "website",
  "_type" : "blog",
  "_id" : "123",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "title" : "My first blog entry",
    "text" : "Just trying this out...",
    "date" : "2014/01/01"
  }
}
```
