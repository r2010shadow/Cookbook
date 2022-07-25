`Helm就是kubernetes的应用程序包管理器`
* 类似于Linux系统上的 yum 或 apt-get 等，可用于实现帮助用户查找，分享及使用kubernetes应用程序，目前的版本由CNCF（Microsoft，Google，Bitnami 和 Helm 社区） 维护。
* yaml文件为硬编码，无变量可欠灵活

* Helm组件及相关术语
```
Helm将kubernetes资源（Deployment，service或configmap等）打包到一个charts中，
制作并测试完成的各个charts 将保存到charts仓库进行存储和分发。

  Helm Client (helm) --> Chart Repository
        |
        |
|-------- K8s Cluster-----------------------------|        
|  Helm Server (Tiller) --> Kubernetes API Server |   
```


`优势`
* 管理复杂应用： charts能够描述哪怕是最复杂的程序结构，其提供了可重复使用的应用安装的定义。
* 易于升级： 使用就地升级和自定义钩子来解决更新的难题。
* 简单分享： charts易于通过公共或私用服务完成版本化，分享及主机构建。
* 回滚：可使用 “helm rollback” 命令轻松实现快速回滚。
