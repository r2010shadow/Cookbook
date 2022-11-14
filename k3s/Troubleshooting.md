
## k8s中删除对象一直处于Terminating


1、命令行强制删除

- 删除POD

kubectl delete pod [pod name] --force --grace-period=0 -n [namespace]

- 删除NAMESPACE

kubectl delete namespace NAMESPACENAME --force --grace-period=0

过滤pod

[root@master ~]# kubectl get pods | grep "Terminating"| awk '{print $1}'

[root@master ~]# kubectl delete pod $(kubectl get pods | grep "Terminating"| awk '{print $1}') --force --grace-period=0 -n <namespace>

2、数据库f方式删除

- 删除 namespace下的pod名为pod-to-be-deleted-0

    export ETCDCTL_API=3

etcdctl del /registry/pods/<namespace>/pod-to-be-deleted-0

- 删除ns

    etcdctl del /registry/namespaces/NAMESPACENAME

- 或者删除

kubectl  get ns xxxxx -o json >xxxxxns.json

修改xxxxxns.json删除其中的spec字段

kubectl proxy --port=8081

curl -k -H "Content-Type: application/json" -X PUT --data-binary @xxxxxns.json http://127.0.0.1:8081/api/v1/namespaces/xxxxx/finalize
```
作者：smileprincexie
链接：https://www.jianshu.com/p/c8621772f776
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```
---
  
  
