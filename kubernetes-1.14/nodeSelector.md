## 调度 
`将一个 Pod 分配到某一个可以满足 Pod 资源请求的节点上，这一过程称之为调度。
- 期望与满足
- - 服务器类型，高性能，高存储
- - 网络类型，网络协议，bond
- - 均衡负载，异地
- - 环境,app,test,prod

- 分组调度
- 压力驱逐
- 服务容灾

## 分组调度
- 标签
```
node 按disktype分组
kubectl label node worker01 disktype=ssd
kubectl label node worker02 disktype=hdd


pod 添加多个标签
kubectl label pod nginx-test app=nginx env=test


集合关系
kubectl get pod -l "app in (web,nginx)" --show-labels
kubectl get pod -l "env notin (product,dev)" --show-labels


查看 所有标签
kubectl get pod [node] --show-labels
```

- 选择器
```
nodeSelector:
  disktype: ssd
```

