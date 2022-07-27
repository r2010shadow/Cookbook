`容器域名解析`
* 根据 /etc/resolv.conf 文件
```
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local lan
options ndots:5
```
* nameserver即为kubernetes集群中kube-dns的svc IP，集群中容器的nameserver均设置为kube-dns。
```
kubectl get svc -n kube-system
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
kube-dns         ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   236d
```
