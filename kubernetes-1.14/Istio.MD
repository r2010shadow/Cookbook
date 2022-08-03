# Service Mesh
`是一个可配置的低延迟的基础设施层，目的是通过API（应用程序编程接口）处理应用程序服务之间的大量基于网络的进程间通信`

- 功能 
`服务发现，负载平衡，加密，可观察性，可追溯性，身份验证和授权，以及对断路器模式的支持`
- 目的
`接管和治理应用程序间的通信，基于 Service Mesh 的服务治理就是在服务的通信或者说调用过程中「做手脚」`
- Control Plane 
`治理规则的控制与下发`
- Data Plane (Sidecar)
`处理服务实例间的通信过程，实施指定的治理策略`
---
## Sidecar 
```
最准确的表述应该是 「Sidecar Proxy」，它的本质是一个代理组件
这个组件会被直接注入到服务实例相同的 Network Namesapce 下
在 Kubernetes 中，就是注入到 Pod 里面，
  此时 Sidecar 与服务实例共享 Pod Network Namespace，
    可以通过 iptables 对流经实例的 inbound 和 outbound 流量进行相应的规则处理。
```
- Sidecar 的注入
`比较核心的就是 Admission Controller 和 Admission Webhook`
- Admission Controller 拦截器
```
拦截 API Server 请求(经过身份验证的)的网关，并且可以修改请求对象或拒绝请求。类似web框架中的middleware，是 Kubernetes API Server 用于拦截请求的一种手段。
Admission Controller有两种：
  一种是内置的
  另一种是用户自定义的(Sidecar Injector)
```
- - Kubernetes 为什么引入 admission 这种机制
```
1. 虽然 Kubernetes 有 Authentication & Authorization 这种认证鉴权机制，Authentication & Authorization 运行在 filter 中，
   只能获取 http 请求 header 以及证书，并不能获取请求的 body。所以不可以对请求的对象进行任何操作，因为获取不到对象。
2. Admission Controller 运行在 API Server 的增删改查 handler 中，可以自然地操作 API resource。
   API Server 接收到客户端请求后首先进行认证鉴权，认证鉴权通过后才会进行后续的 endpoint handler 处理
```
- Sidecar自动注入实现
```
Sidecar Injector 是 Istio 中实现自动注入Sidecar的组件
以 Kubernetes 准入控制器 Admission Controller 的形式运行

```

<img src="https://github.com/r2010shadow/Cookbook/blob/master/kubernetes-1.14/img/istio-injector.png" width=300>
