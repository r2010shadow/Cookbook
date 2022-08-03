`kube-controller-manager 集群状态管理`
* 保证集群中各种资源的实际状态（status）和用户定义的期望状态（spec）一致
* client-go 事件分发
```
核心模块-informer-概括为两点：
资源数据缓存功能，缓解对 kube-apiserver 的访问压力
资源事件分发，触发事先注册好的 ResourceEventHandler
```
- - informer
```
同步数据到本地缓存
Informer 会不断读取 Delta FIFO 队列中的 Object，在触发事件回调之前先更新本地的 store，如果是新增 Object，
  如果事件类型是 Added（添加对象）
     那么 Informer 会通过 Indexer 的库把这个增量里的 API 对象保存到本地的缓存中，并为它创建索引
     之后通过 Lister 对资源进行 List / Get 操作时会直接读取本地的 store 缓存
     通过这种方式避免对 kube-apiserver 的大量不必要请求，缓解其访问压力
根据对应的事件类型，触发事先注册好的 ResourceEventHandler。
  client-go 的 informer 模块启动时会创建一个 shardProcessor，
  各种 controller（如 Deployment Controller、自定义 Controller…）的事件 handler 注册到 informer 的时候会转换为一个 processorListener 实例，然后 processorListener 会被 append 到 shardProcessor 的 Listeners 切片中，shardProcessor 会管理这些 listeners。
```
