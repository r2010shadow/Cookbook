# Kubernetes cooking

* K8S架构

| 特性             | 成员                         | 作用                                                         |
| ---------------- | ---------------------------- | ------------------------------------------------------------ |
| MASTER           |                              |                                                              |
| 8080<br>REST服务 | API Server<br>etcd包含在其中 | 调用进程对NODE部署控制<br>对pod/service/RC增删改查<br>集群模块间数据交换的枢纽<br>etcd存储资源信息 |
|                  | Scheduler                    | 调度pod到NODE，下达任务给NODE<br/>待调度的 Pod、可用的 Node，调度算法和策略 |
|                  | Controller                   | 8 个 Controller，分别对应着副本，节点，资源，命名空间，服务等等 |
| Node             |                              |                                                              |
|                  | kubelet                      | 按schedule说的做，用于处理 Master 下发到 Node 的任务<br>向apiserver注册node信息，通过cAdvisor监控容器 |
|                  | kebu proxy                   | 负责实施 反向代理、负载均衡                                  |
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

| Info         | Script                                                       |
| ------------ | ------------------------------------------------------------ |
| POD_NAME     | export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') |
| NODE_PORT    | export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}') |
| NodePort     | kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080 |
| POD,api,info | curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/ |
| proxy,status | curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/ |


* 分析
```
sudo yum install util-linux -y                      # setup nsenter
sudo nsenter -t PID -n tcpdump -i eth0 udp port 53  # DNS

```


## Yaml tips
<img src="https://github.com/r2010shadow/Cookbook/blob/master/kubernetes-1.14/img/k8s.yaml.tips..png" width=600>


---
CNI Container Network Interface
kubernetes 的网络通信可以分为三层去看待：

- Pod 内部容器通信
`共享Network Namespace`
- 同主机 Pod 间容器通信
`共享主机网卡，每个容器都是用docker0与之通信`
- 跨主机 Pod 间容器通信
`CNI`
