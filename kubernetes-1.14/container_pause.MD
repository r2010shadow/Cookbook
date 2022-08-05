```
为什么每个 Pod 有个 eth0 ？为什么 Pod 是一个抽象的虚拟的概念，自己还能有一个独立的网络协议栈，即 Network Namespace，还能挂载一个 Veth 设备？
实际上每个 Pod 默认会有一个 pause 容器
```

## 管家容器 google_containers/pause
`pod加入（join）另一个第三方容器(pause)的 network namespace 实现的网络共享`
- pause 容器负责了包括 Pod 网络相关的一些初始化工作
- pause 容器使用的就是之前讲到的 Docker 的默认网络通信模型 Bridge
- pause 通过 Veth 设备对与 docker0 桥接
- -  而 Pod 内的其它容器采用了非默认的网络配置和映射容器的模型，指定映射目标容器到 Pause 容器上 ，这么做的目的很简单，为实现一个 Pod 内多个容器，本身没有很好的方式进行连接，pause 提供一个 Pod 内部的通信「桥梁」

## 共享ns示例
一个pod至少有2个容器(1个业务+1个pause)
- 创建 pause 容器
```
sudo docker run -d -p 8888:80 \
        --ipc=shareable \
        --name fake_k8s_pod_pause \
        registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.6
```
- 创建 nginx 容器
- -  nginx.conf 配置文件
```
cat <<EOF >> nginx.conf
error_log stderr;
events { worker_connections  1024; }
http {
    access_log /dev/stdout combined;
    server {
        listen 80 default_server;
        server_name iswbm.com www.iswbm.com;
        location / {
            proxy_pass http://127.0.0.1:2368;
        }
    }
}
EOF
```
- - nginx 容器
加入 fake_k8s_pod_pause 的net/ipc/pid的namespace
```
sudo docker run -d --name fake_k8s_pod_nginx \
        -v `pwd`/nginx.conf:/etc/nginx/nginx.conf \
        --net=container:fake_k8s_pod_pause \
        --ipc=container:fake_k8s_pod_pause \
        --pid=container:fake_k8s_pod_pause \
        nginx
```
- 创建 ghost 容器
博客应用,提供网页的数据，同样加入 fake_k8s_pod_pause 的net/ipc/pid的namespace
```
sudo docker run -d --name ghost \
        --net=container:fake_k8s_pod_pause \
        --ipc=container:fake_k8s_pod_pause \
        --pid=container:fake_k8s_pod_pause 
        ghost
```
- 访问 “Pod” 服务 http://172.20.20.11:8888/

## 创建真正的 Pod
K8S 的 Pod，这三个容器在逻辑上就是一个整体，创建 Pod 就会自动创建三个容器，删除 Pod 就会删除三个容器，从管理上来讲，方便了不少。
- 创建 ConfigMap
挂载配置，供容器领用
```
kubectl create configmap nginx-config --from-file=nginx.conf
```
- 创建 Pod
- - ghost.yaml
```
cat <<EOF >> ghost.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ghost
  namespace: default
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    ports:
    - containerPort: 80
      protocol: TCP
      hostPort: 8888
      volumeMounts:
    - mountPath: /etc/nginx/
      name: nginx-config
      readOnly: true
  - image: ghost
    name: ghost
    volumes:
  - name: nginx-config
    configMap:
      name: nginx-config
EOF
```
- - 实际创建
```
kubectl apply -f ghost.yaml
kubectl get pod
```
- 访问 http://172.20.20.11:8888/ 
---




