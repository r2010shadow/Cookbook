# Kubernetes cooking

[kubectl_备忘单](https://kubernetes.io/zh-cn/docs/reference/kubectl/cheatsheet/)  [kubectl_命令参考](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)

* K8S架构

| 特性             | 成员                         | 作用                                                         |
| ---------------- | ---------------------------- | ------------------------------------------------------------ |
| MASTER           |                              |                                                              |
| 8080<br>REST服务 | API Server<br>etcd包含在其中 | 调用进程对NODE部署控制<br>对pod/service/RC增删改查<br>集群模块间数据交换的枢纽<br>etcd存储资源信息 |
|                  | Scheduler                    | 调度pod到NODE，下达任务给NODE<br/>待调度的 Pod、可用的 Node，调度算法和策略 |
|                  | Controller                   | 8 个 Controller，分别对应着副本，节点，资源，命名空间，服务等等 |
| Node             |                              |                                                              |
|                  | kubelet                      | 按schedule说的做，用于处理 Master 下发到 Node 的任务<br>向apiserver注册node信息，通过cAdvisor监控容器 |
|                  | kube_proxy                   | 负责实施 反向代理、负载均衡                                  |
| kubectl          |                              | 下发指令                                                     |

* APISERVER

| 特性              | 架构从上到下分为四层                                         |
| ----------------- | ------------------------------------------------------------ |
| **API层**         | 以 REST 方式提供各种 API 接口                                |
| **访问控制层**    | 身份鉴权，核准用户对资源的访问权限，设置访问逻辑（Admission Control） |
| **注册表层**      | 选择要访问的资源对象<br>所有资源对象都保存在[注册表](https://www.zhihu.com/search?q=注册表&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"article"%2C"sourceId"%3A96908130})（Registry）中，例如：Pod，Service，Deployment 等。 |
| **etcd 数据库层** | 持久化 Kubernetes 资源对象的 Key-Value 数据库                |

* kube-proxy  

| 特性     | 看作 Service 的负载均衡器                                    |
| -------- | ------------------------------------------------------------ |
| 内外连通 | kube-proxy 服务通过 iptables 的 NAT 转换，实现Cluster-IP到NodePort |


* Service

| 特性        | 提供访问途径                                                 |
| ----------- | ------------------------------------------------------------ |
| pod访问     | 定义了一个服务的访问入口地址（IP+Port）。<br>Pod 中的应用通过这个地址访问一个或者一组 Pod 副本 |
| 特定pod访问 | 通过 Label Selector 来实现连接的。Service 所访问的这一组 Pod 都会有同样的 Label |
| Cluster-IP  | 虚拟的 IP，仅供 Kubernetes 内部的 Pod 之间的通信，ping不通   |

* KUBECTL命令

| kubectl                                                      |                                            |
| ------------------------------------------------------------ | ------------------------------------------ |
| apply -[f YAML, -k ./目录下所有]                             | 部分改动                                   |
| create -f<br>create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1 | 单次完整创建                               |
| get [-l 标签内容，从describe查看，-o wide --watch持续查看]<br> [pods,deployments,services,rs] | 获取                                       |
| describe                                                     | 描述                                       |
| logs                                                         |                                            |
| exec $POD_NAME -- env                                        |                                            |
| exec -it $POD_NAME -- bash                                   |                                            |
| expose [deployment/NAME --type="" --port "PORT"]             | 开放端口                                   |
| label pods $POD_NAME [添加label的内容 比如version=v1]        | 添加标签                                   |
| delete [-l 标签内容，从describe查看,  -k ./目录下所有]       |                                            |
| scale [deployments/NAME -- replicas=数字]<br> scale deployments/kubernetes-bootcamp --replicas=4 | 水平扩展                                   |
| **set** image deployments/kubernetes-bootcamp kubernetes-  bootcamp=jocatalin/kubernetes-bootcamp:v2 | 更新                                       |
| rollout status deployments/kubernetes-bootcamp               | 更新状态                                   |
| rollout **undo** deployments/kubernetes-bootcamp             | 回滚到前一次                               |
| cluster-info   包括cluster-info，KubeDNS                     |                                            |
| wait<br> wait --for=condition=ready pod -l app=inventory     | condition met                              |
| replace<br> replace --force -f kubernetes.yaml               | 更新yaml                                   |
| port-forward svc/frontend 8080:80                            | 将本机的 `8080` 端口转发到服务的 `80` 端口 |



* 对比apply和create

| 序号 | kubectl apply     (=create+replace)                          | kubectl create                                               |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | 根据yaml文件中包含的字段（yaml文件可以只写需要改动的字段），直接升级集群中的现有资源对象 | 首先删除集群中现有的所有资源，然后重新根据yaml文件（必须是完整的配置信息）生成新的资源对象 |
| 2    | yaml文件可以**不完整**，只写需要的字段                       | yaml文件必须是**完整**的配置字段内容                         |
| 3    | kubectl apply只工作在yaml文件中的某些**改动**过的字段        | kubectl create工作在yaml文件中的**所有**字段                 |
| 4    | 在只改动了yaml文件中的某些声明时，而不是全部**改动**，你可以使用kubectl apply | 在没有改动yaml文件时，使用同一个yaml文件执行命令kubectl replace，将不会成功（fail掉），因为缺少相关改动信息 |


* Endpoint

| 特性                                                         |      |
| ------------------------------------------------------------ | ---- |
| 一个Service对应的所有Pod副本的访问地址                       |      |
| Node上的Kube-proxy进程获取每个Service的Endpoints，实现Service的负载均衡功能 |      |
| pod状态为running + service关联 = endpoint                    |      |



* 调试
```
简化输入
alias kc="kubectl"
alias ka="kubectl apply -f"
alias kd="kubectl delete -f"
```

| Info                                               | Script、kubectl                                              |
| -------------------------------------------------- | ------------------------------------------------------------ |
| pod_name                                           | export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') |
| pod_name                                           | kubectl get pods -A -o=name                                  |
| NODE_PORT                                          | export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}') |
| NODE_PORT                                          | kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080 |
| POD,api,info                                       | curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/ |
| proxy,status                                       | curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/ |
| 当前命名空间中正在运行的 Pods                      | kubectl get pods --field-selector=status.phase=Running       |
| 所有工作节点                                       | kubectl get node --selector='!node-role.kubernetes.io/master' |
| 所有 Services                                      | kubectl get services --sort-by=.metadata.name                |
| 全部节点的 ExternalIP 地址                         | kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}' |
| Pod 使用的全部 Secret                              | kubectl get pods -o json \| jq '.items[].spec.containers[].env[]?.valueFrom.secretKeyRef.name' \| grep -v null \| sort \| uniq |
| 运行着的所有镜像                                   | kubectl get pods -A -o=custom-columns='DATA:spec.containers[*].image' |
| 按重启次数排序列出pod                              | kubectl get pods --sort-by='.status.containerStatuses[0].restartCount' |
| 按容量排序PV 持久卷                                | kubectl get pv --sort-by=.spec.capacity.storage              |
| 按时间戳排序列出事件                               | kubectl get events --sort-by=.metadata.creationTimestamp     |
| 比较当前的集群状态和假定某清单被应用之后的集群状态 | kubectl diff -f ./my-manifest.yaml                           |
| 查看Pod 负载情况                                   | kubectl top pod POD_NAME --sort-by=cpu  </br> kubectl top pod POD_NAME --containers |


* 分析
```
sudo yum install util-linux -y                      # setup nsenter
sudo nsenter -t PID -n tcpdump -i eth0 udp port 53  # DNS

```


## Yaml tips
<img src="https://github.com/r2010shadow/Cookbook/blob/master/kubernetes-1.14/img/k8s.yaml.tips..png" width=600>


---

`CNI Container Network Interface`

kubernetes 的网络通信可以分为三层：
- Pod 内部容器通信
`共享Network Namespace`
- 同主机 Pod 间容器通信
`共享主机网卡，每个容器都是用docker0与之通信`
- 跨主机 Pod 间容器通信
`CNI`

CNI 插件通常有三种实现模式：
- Overlay：靠隧道打通，不依赖底层网络
```
属于应用层网络，它是面向应用层的，不考虑网络层，物理层的问题。

Flannel
```
- 路由：靠路由打通，部分依赖底层网络
- Underlay：靠底层网络打通，强依赖底层网络

Flannel
`将 TCP 数据包装在另一种网络包里面进行路由转发和通信，目前已经支持 UDP、VxLAN、AWS VPC 和 GCE 路由等数据转发方式。`
`规定宿主机下各个Pod属于同一个子网，不同宿主机下的Pod属于不同的子网`

支持3种实现：UDP、VxLAN、host-gw，
- UDP 模式：    使用设备 flannel.0 进行封包解包，不是内核原生支持，频繁地内核态用户态切换，性能非常差；
```
UDP 模式的核心就是通过 TUN 设备 flannel0 实现。TUN设备是工作在三层的虚拟网络设备，功能是：在操作系统内核和用户应用程序之间传递IP包。
```
- VxLAN 模式：  使用 flannel.1 进行封包解包，内核原生支持，性能较强；性能损失大约在20%~30%
```
是由flanneld进程维护的 linux内核再在IP包前面加上二层数据桢头，把Node2的MAC地址填进去。这个MAC地址本身，是Node1的ARP表要学习的，需 Flannel维护
```
- host-gw 模式：   无需 flannel.1 这样的中间设备，直接宿主机当作子网的下一跳地址，性能最强； 性能损失大约在10%

--- 
`kubeadm 维护类`
- 驱逐这个节点上的所有pod
`kubectl drain NODENAME --delete-local-data --force --ignore-daemonsets`
```
 --ignore-daemonsets往往需要指定的,这是因为deamonset会忽略unschedulable标签(使用kubectl drain时会自动给节点打上不可调度标签),
因此deamonset控制器控制的pod被删除后可能马上又在此节点上启动起来,这样就会成为死循环.因此这里忽略daemonset.

使用kubectl drain时候,命令行一直被阻塞,等了很久还在被阻塞.比如某pod一直处于Terminating状态.
  来强制马上删除pod  kubectl delete pods busybox --grace-period=0 --force
```

- 清除节点
`kubectl del node NODENAME`

- 节点重置安装
`kubeadm reset`

- 重置iptables
`iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X`

- 重置ipvs
`ipvsadm -C`

- 重新加入集群
```
    kubeadm reset
    systemctl stop kubelet
    systemctl stop docker
    rm -rf /var/lib/cni/
    rm -rf /var/lib/kubelet/*
    rm -rf /etc/cni/
    ifconfig cni0 down
    ifconfig flannel.1 down
    ifconfig docker0 down
    ip link delete cni0
    ip link delete flannel.1
    systemctl start docker

    kubeadm join XXXXX
```

- kubectl命令行补全
```
yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
```
