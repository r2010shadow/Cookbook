`特性`
```
静态 Pod 直接由特定节点上的 kubelet 进程来管理，不通过 master 节点上的 apiserver 。
⽆法与我们常⽤的控制器 Deployment 或者 DaemonSet 进⾏关联，
它由 kubelet 进程自己来监控，当 pod 崩溃时重启该 pod ， kubelete 也⽆法对他们进⾏健康检查。
静态 pod 始终绑定在某⼀个 kubelet ，并且始终运⾏在同⼀个节点上。 
kubelet 会⾃动为每⼀个静态 pod 在 Kubernetes 的 apiserver 上创建⼀ 个镜像 Pod（Mirror Pod），
因此我们可以在 apiserver 中查询到该 pod，但是不能通过 apiserver 进 ⾏控制（例如不能删除）。
```

`创建静态Pod  配置⽂件和 HTTP `
* 通过配置文件创建Pod
```
kubelet启动配置⽂件
  systemctl status kubelet
  /usr/lib/systemd/system/kubelet.service.d
     └─10-kubeadm.conf

添加环境变量配置     
  Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allowprivileged=true"     

静态 Pod 文件的路径( kubeadm 的⽅式来安装的集群环境)
  /etc/kubernetes/manifests

编写yaml
# /etc/kubernetes/manifest/static-web.yaml
apiVersion: v1
kind: Pod
metadata:
  name: static-web
  labels:
    app: static
spec:
  containers:
    - name: web
      image: nginx
      ports:
        - name: web
          containerPort: 80

kubelet 启动时，由 –pod-manifest-path= 或者 –manifest-url= 参数指定的⽬录下定义的所有 pod 都会自动创建，例如，我们示例中的 static-web

静态pod清理，通过把Yaml文件删除、再次执行 kubectl get pods 验证。
