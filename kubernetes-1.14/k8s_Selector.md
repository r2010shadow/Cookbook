## 调度 
`将一个 Pod 分配到某一个可以满足 Pod 资源请求的节点上，这一过程称之为调度。`
- 期望与满足
- - 服务器类型 高性能，高存储
- - 网络类型 网络协议，bond
- - 均衡负载 异地
- - 环境 app,test,UAT,prod

- 分组调度
`pod调度 指定label的pod到何处nodeselector`
- 压力驱逐
`node调度 专属节点，运行那些pod入驻`
- 服务容灾
---
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
---
## 压力驱逐
- 污点

`设置node节点为专业节点`
```
# node上设置
kubectl taint nodes worker02 gpu=true:NoSchedule   
#   取消设置
kubectl taint nodes worker02 gpu=true:NoSchedule-   

# pod上 spec下
tolerations:
- key: "gpu"
  operator: "Equal"
  value: "true"
  effect: "NoSchedule"

```

- - kubelet主动为node打上有意义的标记
```
比如内存比较紧张的话，会打上 node.kubernetes.io/memory-pressure

比如磁盘比较紧张的话，会打上 node.kubernetes.io/disk-pressure

比如 pid 比较紧张的话，会打上 node.kubernetes.io/pid-pressure

node.kubernetes.io/not-ready：节点未准备好。这相当于节点状态 Ready 的值为 “False”

node.kubernetes.io/unreachable：节点控制器访问不到节点. 这相当于节点状态 Ready 的值为 “Unknown”。

node.kubernetes.io/network-unavailable：节点网络不可用。

node.kubernetes.io/unschedulable: 节点不可调度。
```


- 容忍度

`一个 Node 上可以设置多个污点，一个 Pod 也可以设置多个容忍度。`
- - key：键（必填）
- - value：值`当 operator 为 Equal ，value 必填，当 operator 为 Exists ，value 就不用填写`
- - operator：操作 `可以为 Exists （存在即可匹配） 或者 Equal （value 必须与相等才算匹配）`
- - effect：影响 `有三个选项：NoSchedule(不可调度)、PreferNoSchedule（可尝试调度）、NoExecute`

---
## 服务容灾

`有利于集群运作，与有利于均衡负载，将关系中的pod调度到一起。nodeSelector行为即亲和`
- - nodeAffinity(node 亲和性) `该 Pod 有必要调度到什么样的 Node 上`

- - podAffinity(pod 亲和性) `该 Pod 有必要和某些 Pod 调度在一起`

- - podAntiAffinity(pod 反亲和性) `该 Pod 没有必要和某些 Pod 调度在一起`

- 硬策略的做法
```
就是换个模式的 nodeSelector，它是强制性的，必须的，不满足就调度失败。
requiredDuringSchedulingIgnoredDuringExecution ==> 硬策略

node 亲和性 + 硬策略 <禁止 调度到 worker01 上>
  
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:  # 硬策略
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: NotIn  # 判断
          values:
          - worker01
```

- 软策略的做法
```
则更灵活，可以选择满足条件的，尽可能的，要是真没有满足条件的，就调度到其他节点上
preferredDuringSchedulingIgnoredDuringExecution ==> 软策略

node 亲和性 + 软策略 <尽量 调度到有 ssd 的节点上> 

affinity:
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:  # 软策略
    - weight: 100    # 权重
      preference:
        matchExpressions:
        - key:  disktype
          operator: In   
          values:
          - ssd 
```


- operator 操作的可选项及其含义：
```
In：label 的值在某个列表中

NotIn：label 的值不在某个列表中

Gt：label 的值大于某个值

Lt：label 的值小于某个值

Exists：某个 label 存在

DoesNotExist：某个 label 不存在
```

