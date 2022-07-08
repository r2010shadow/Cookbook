## 由来
```
HBase解决了HDFS解决不了的问题：
HDFS是文件系统，文件放上去只能查不能改，是无序存放的；
HBase可以增删改; HBase是基于HDFS，运行在HDFS之上的, 有序存放的。
```

## 架构
* Client
```
Client 包含了访问 Hbase 的接口，另外 Client 还维护了对应的 cache 来加速 Hbase的访问，比如 cache 的.META.元数据的信息。
```
* ZooKeeper
```
HBase 通过 Zookeeper 来做 master 的高可用、RegionServer 的监控、元数据的入口以及集群配置的维护等工作。
```
* Hmaster
```
1．监控 RegionServer
2．处理 RegionServer 故障转移
3．处理元数据的变更
4．处理 region 的分配或转移
5．在空闲时间进行数据的负载均衡
6．通过 Zookeeper 发布自己的位置给客户端
```
* Hregionserver
```
1．负责存储 HBase 的实际数据
2．处理分配给它的 Region
3．刷新缓存到 HDFS
4．维护 Hlog
5．执行压缩
6．负责处理 Region 分片
```
* HDFS
```
HDFS 为 Hbase 提供最终的底层数据存储服务，同时为 HBase 提供高可用（Hlog 存储在 HDFS）的支持，具体功能概括如下：
提供元数据和表数据的底层分布式存储服务
数据多副本，保证的高可靠和高可用性
```
