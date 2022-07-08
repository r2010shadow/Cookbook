## 概念
```
Kafka是一种高吞吐量的分布式发布订阅消息系统，有如下特性：

通过O(1)的磁盘数据结构提供消息的持久化，这种结构对于即使数以TB的消息存储也能够保持长时间的稳定性能。（文件追加的方式写入数据，过期的数据定期删除）
高吞吐量：即使是非常普通的硬件Kafka也可以支持每秒数百万的消息。
支持通过Kafka服务器和消费机集群来分区消息。
支持Hadoop并行数据加载。

Kafka相关概念

Broker
Kafka集群包含一个或多个服务器，这种服务器被称为broker[5]

Topic
每条发布到Kafka集群的消息都有一个类别，这个类别被称为Topic。（物理上不同Topic的消息分开存储，逻辑上一个Topic的消息虽然保存于一个或多个broker上但用户只需指定消息的Topic即可生产或消费数据而不必关心数据存于何处）

Partition
Parition是物理上的概念，每个Topic包含一个或多个Partition.

Producer
负责发布消息到Kafka broker

Consumer
消息消费者，向Kafka broker读取消息的客户端。

Consumer Group
每个Consumer属于一个特定的Consumer Group（可为每个Consumer指定group name，若不指定group name则属于默认的group）。

一般应用在大数据日志处理或对实时性（少量延迟），可靠性（少量丢数据）要求稍低的场景使用。
```
