```
为什么每个 Pod 有个 eth0 ？为什么 Pod 是一个抽象的虚拟的概念，自己还能有一个独立的网络协议栈，即 Network Namespace，还能挂载一个 Veth 设备？
实际上每个 Pod 默认会有一个 pause 容器
```

## 管家容器 google_containers/pause

- pause 容器负责了包括 Pod 网络相关的一些初始化工作
- pause 容器使用的就是之前讲到的 Docker 的默认网络通信模型 Bridge
- pause 通过 Veth 设备对与 docker0 桥接
- -  而 Pod 内的其它容器采用了非默认的网络配置和映射容器的模型，指定映射目标容器到 Pause 容器上 ，这么做的目的很简单，为实现一个 Pod 内多个容器，本身没有很好的方式进行连接，pause 提供一个 Pod 内部的通信「桥梁」
