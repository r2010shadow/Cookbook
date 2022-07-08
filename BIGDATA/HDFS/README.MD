# Hadoop Distributed File System
[Apache Hadoop 3.3.3](https://hadoop.apache.org/docs/stable/index.html)

## 由来
```
RAID技术只是在单台服务器的多块磁盘上组成阵列，大数据需要更大规模的存储空间和访问速度。
将RAID技术原理应用到分布式服务器集群上，就形成了Hadoop分布式文件系统HDFS的架构思想。
```
## 场景

* 适合
```
存储超大文件
流式的数据访问
一次写入，多次读取
```
* 不适合
```
存储小于150字节块大小的文件
交互式处理（ HBase 满足低延迟用户的访问需求）
同时有多个写入，对文件的任意位置进行修改
```

## 主从架构
```
一个HDFS集群会有一个NameNode（命名节点，简称NN），作为主服务器（master server）。
NameNode用于管理文件系统的命名空间以及调节客户访问文件还有多个DataNode。
DataNode（简称DN），数据节点，作为从节点（slave server）存在通常每个集群中的DataNode，
都会被NameNode所管理，DataNode用于存储数据。
```

## 语法
`hdfs dfs -<命令> hdfs://<ip>:<port>//<path>`
