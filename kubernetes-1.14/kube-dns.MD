`容器域名解析`
* 根据 /etc/resolv.conf 文件
```
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local lan
options ndots:5
```
- - nameserver即为kubernetes集群中kube-dns的svc IP，集群中容器的nameserver均设置为kube-dns。
```
kubectl get svc -n kube-system
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
kube-dns         ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   236d
```

- - 参数search与ndots
```
FQDN是完整域名，域名最终以.结束。google.com.

系统判断
  是FQDN
    操作系统会 直接查询 DNS
  非FQDN
    用search和ndots

域名中.个数 >= ndots
  则改域名为一个FQDN
域名中.个数 < ndots
  系统会在search搜索域中进行查询

ndots 表示的是域名中必须出现的.的个数
ndots默认值为1，只要域名中有一个 . ，操作系统就会认为是绝对域名，直接查询。

ndots为5，查询的域名google.com不以.结尾，同时 . 的个数少于5，因此操作系统会依此在四个域中进行了搜索:
default.svc.cluster.local    # 由kubernetes注入
svc.cluster.local            # 由kubernetes注入
cluster.local                # 由kubernetes注入
lan                          # 操作系统默认的搜索域
```
- - ndots修改,通过pod.Spec.DNSConfig改写
```
apiVersion: v1
kind: Pod
metadata:
  namespace: default
  name: dns-example
spec:
  containers:
    - name: test
      image: nginx
  dnsConfig:
    options:
      - name: ndots
        value: "2"
```
* dns cache 待查
