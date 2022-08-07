## init 容器
在应用（业务）容器启动之前运行初始化任务，用来包含一些应用镜像中不存在的实用工具或安装脚本。

## init 容器 VS pause 容器
- 相同点在于：它们都有固定用途，是专用的特殊容器
- 不同点在于： init容器是用户级的容器，它是由用户来定义的，而 pause 容器是系统级容器，它不是由用户定义的。

## init 容器 VS 应用容器
- 定义位置不同
应用容器定义在 Pod.Spec.Containers，是必填字段，而 init 是定义在 Pod.Spec.initContainers 中，是可选字段。

- 部分配置不同
init 容器没有 Lifecycle actions, Readiness probes, Liveness probes 和 Startup probes，而这些应用容器都有。

- 名字不能重复
虽然 init 容器与应用容器是两个类别的容器，但由于属于同一个 Pod ，因此容器的名字，是不能重复的。

## init 容器的运行机制
- init 容器必须先于 应用容器启动
- 仅当 init 容器完成后，才能运行应用容器
- 一个 Pod 允许有多个 init 容器，做不同的初始化任务
- 当一个 Pod 有多个 init 容器时，这些 init 容器是顺序运行的，一个 init 容器完成之后，才会运行一个 init 容器。

## init 容器的资源问题
根据requests/limits 的总量 ， 加上init容器请求资源之和，选择可调度的Node worker01.
```
# init-pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: test-init-pod
  labels:
    app: init
spec:
  containers:
  - name: myapp
    image: busybox
    resources:
      requests:
        cpu: 100m  
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-01
    image: busybox
    command: ['sh', '-c', 'sleep 10']
    resources:
      requests:
        cpu: 20m
  - name: init-02
    image: busybox
    command: ['sh', '-c', 'sleep 10']
    resources:
      requests:
        cpu: 30m
```
kubectl apply -f init-pod.yml
使用 kubectl describe node worker01 可以找到test-init-pod的 requests.cpu 总量计算为 100m，这刚好是应用容器的 requests.cpu

## init 容器的应用场景
- web + db
- 前置容器中的资源(如ffmpeg) + app 







