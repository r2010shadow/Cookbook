


`PromQL 时间序列`
```
采集到的样本数据以时间序列（time-series）的方式保存在内存数据库中，并且定时保存到硬盘上。
向量(vector): time-series是按照时间戳和值的序列顺序存放
每条time-series通过指标名称(metrics name)和一组标签集(labelset)命名
```

* 采集样本
```
  node_cpu{cpu="cpu0",mode="idle"} 362812.7890625
     |            |                        |
  指标的名称    特征和维度               采集到的数值


  ^
  │   . . . . . . . . . . . . . . . . .   . .   node_cpu{cpu="cpu0",mode="idle"}
  │     . . . . . . . . . . . . . . . . . . .   node_cpu{cpu="cpu0",mode="system"}
  │     . . . . . . . . . .   . . . . . . . .   node_load1{}
  │     . . . . . . . . . . . . . . . .   . .  
  v
    <------------------ 时间 ---------------->
    在time-series中的 每一个点 称为 一个样本（sample）
```
* 样本组成
```
  指标(metric)：metric name和描述当前样本特征的labelsets
     |                                        时间戳精确到毫秒
     |                                            |    
<metric name>{<label name>=<label value>, ...}@timestamp => value
      |             |                                         |          
   样本的含义     标签过滤/聚合                     样本值float64的浮点型数据
```
 
* 指标(Metric)
```
<--------------- metric ---------------------><-timestamp -><-value->
http_request_total{status="200", method="GET"}@1434417560938 => 94355
http_request_total{status="200", method="GET"}@1434417561287 => 94334
```

[Handbook](https://prometheus.fuckcloudnative.io/)
---
`部署`
[Download](https://prometheus.io/download/)
* prometheus.yml 定制
* 启动 
`./prometheus --config.file=prometheus.yml`
- - 启动容器
```
docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml \
       prom/prometheus
# 有状态，带数据卷
docker run -p 9090:9090 -v /prometheus-data \
       prom/prometheus --config.file=/prometheus-data/prometheus.yml
```
* 访问
- - 页面
`localhost:9090` 
- - metrics 端点
`localhost:9090/metrics`
- - `表达式浏览器`
`http://localhost:9090/graph`
---
## 本地存储 不能实现长期的持久化存储
```
如果本地存储出现故障
最好的办法是停止运行 Prometheus 并删除整个存储目录。因为 Prometheus 的本地存储不支持非 POSIX 兼容的文件系统，一旦发生损坏，将无法恢复。
除了删除整个目录之外，你也可以尝试删除个别块目录来解决问题。删除每个块目录将会丢失大约两个小时时间窗口的样本数据。
```
- 数据存储角色
```
Prometheus 按照两个小时为一个时间窗口
  将两小时内产生的数据存储在一个块（Block）中
    每个块都是一个单独的目录
      里面含该时间窗口内的所有样本数据（chunks）
      元数据文件（meta.json）
      以及索引文件（index）      
    其中索引文件会将指标名称和标签索引到样板数据的时间序列中。
    此期间如果通过 API 删除时间序列，删除记录会保存在单独的逻辑文件 tombstone 当中。
```
- 预写日志（write-ahead-log(WAL)）
```
为了确保 Prometheus 发生崩溃或重启时能够恢复数据，Prometheus 启动时会通过预写日志（write-ahead-log(WAL)）重新记录，从而恢复数据。
预写日志文件保存在 wal 目录中，
  每个文件大小为 128MB。
  wal 文件包括还没有被压缩的原始数据，所以比常规的块文件大得多。
  一般情况下，Prometheus 会保留三个 wal 文件，但如果有些高负载服务器需要保存两个小时以上的原始数据，wal 文件的数量就会大于 3 个。
./data 
   |- 01BKGV7JBM69T2G1BGBGM6KB12 # 块
      |- meta.json  # 元数据
      |- wal        # 写入日志
        |- 000002
        |- 000001
   |- 01BKGTZQ1SYQJTR4PB43C8PD98  # 块
      |- meta.json  #元数据
      |- index   # 索引文件
      |- chunks  # 样本数据  每一个样本大概占用1-2字节大小
        |- 000001
      |- tombstones # 逻辑数据
   |- 01BKGTZQ1HHWHV8FBJXW1Y3W0K
      |- meta.json
      |- wal
        |-000001
```
- Prometheus Server 的本地磁盘空间做容量规划
```
needed_disk_space = retention_time_seconds * ingested_samples_per_second * bytes_per_sample
                               |                   |                             |
            保留时间（retention_time_seconds）       |            和 样本大小（bytes_per_sample） 不变的情况下，
  如果想减少本地磁盘的容量需求，                        |
                    只能通过减少  每秒获取样本数（ingested_samples_per_second） 的方式。    
  因此有两种手段，
    一是减少时间序列的数量，
    二是增加采集样本的时间间隔。
  考虑到 Prometheus 会对时间序列进行压缩效率，减少时间序列的数量效果更明显。
```
## 远程存储
```
通过定义两个标准接口（remote_write/remote_read），让用户可以基于这两个接口对接将数据保存到任意第三方的存储服务中，这种方式在 Promthues 中称为 Remote Storage。
```
- remote_write
```
指定 Remote Write（远程写）的 URL 地址，一旦设置了该配置项，Prometheus 将采集到的样本数据通过 HTTP 的形式发送给适配器（Adaptor）。
而用户则可以在适配器中对接外部任意的服务。外部服务可以是真正的存储系统，公有云的存储服务，也可以是消息队列等任意形式。
```
- remote_read
```
通过了一个适配器实现。在远程读的流程当中，当用户发起查询请求后，Promthues 将向 remote_read 中配置的 URL 发起查询请求（matchers,ranges），
Adaptor 根据请求条件从第三方存储服务中获取响应的数据。同时将数据转换为 Promthues 的原始样本数据返回给 Prometheus Server。
当获取到样本数据后，Promthues 在本地使用 PromQL 对样本数据进行二次处理。
```
---
