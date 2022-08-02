`PolarDB-X 是一款面向超高并发、海量存储、复杂查询场景设计的 云原生 分布式 数据库系统。`
[Handbook](https://polardbx.com/document)

| 组件名称                                | 仓库地址                                                 |
| --------------------------------------- | -------------------------------------------------------- |
| 计算节点 （CN, Compute Node）           | [galaxysql](https://github.com/ApsaraDB/galaxysql)       |
| 元数据服务 （GMS, Global Meta Service） | [galaxyengine](https://github.com/ApsaraDB/galaxyengine) |
| 存储节点 （DN, Data Node）              | [galaxyengine](https://github.com/ApsaraDB/galaxyengine) |
| 日志节点 （CDC, Change Data Capture）   | [galaxycdc](https://github.com/ApsaraDB/galaxycdc)       |
| 私有协议                                | [galaxyglue](https://github.com/ApsaraDB/galaxyglue)     |
| K8S Operator                            | [galaxykube](https://github.com/ApsaraDB/galaxykube)     |


- 高可用与容灾（WIP）master*3
- 分布式事务 保证事务的ACID性质
- 水平扩展 支持哈希（Hash）、范围（Range）等常用的分区函数
- 全局二级索引
- 混合负载HTAP
- 全局变更日志CDC
- MySQL生态兼容

