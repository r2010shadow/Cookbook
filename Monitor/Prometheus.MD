
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
