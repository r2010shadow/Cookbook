
## 运行 ZooKeeper，一个分布式协调系统
```
- 如何使用 StatefulSet 部署一个 ZooKeeper ensemble。
- 如何一致性配置 ensemble。
- 如何在 ensemble 中 分布 ZooKeeper 服务器的部署。
- 如何在计划维护中使用 PodDisruptionBudgets 确保服务可用性
```

```
| kubectl apply -f zookeeper.yaml                              |                                               |
| ------------------------------------------------------------ | --------------------------------------------- |
| kubectl get pods -w -l app=zk                                |                                               |
| for i in 0 1 2; do kubectl exec zk-$i -- hostname; done      | 获取 `zk` StatefulSet 中 Pods 的主机名        |
| for i in 0 1 2; do echo "myid zk-$i";kubectl exec zk-$i -- cat /var/lib/zookeeper/data/myid; done | 检查每个服务器的 `myid` 文件的内容            |
| for i in 0 1 2; do kubectl exec zk-$i -- hostname -f; done   | 获取 `zk` StatefulSet 中每个 Pod 的全限定域名 |
| kubectl exec zk-0 -- cat /opt/zookeeper/conf/zoo.cfg         | 查看 `zoo.cfg` 文件的内容                     |
|                                                              |                                               |
```
