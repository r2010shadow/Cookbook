# sentinel 分布式系统的流量防卫兵
* 流量控制
```
流量控制有以下几个角度:

资源的调用关系，例如资源的调用链路，资源和资源之间的关系；
运行指标，例如 QPS、线程池、系统负载等；
控制的效果，例如直接限流、冷启动、排队等。
Sentinel 的设计理念是让您自由选择控制的角度，并进行灵活组合，从而达到想要的效果。
```

* 熔断|降级
```
资源的调用进行限制，让请求快速失败，避免影响到其它的资源而导致级联故障。
服务熔断：接口调用时间（服务响应时间）超过指定时间

服务降级：一段时间内不能再次访问这个接口

接口调用时间（服务响应时间）超过指定时间，一段时间内不能再次访问这个接口
```

* sentinel特性
```
丰富的应用场景:  Sentinel承接了阿里巴巴近十年的双十一大促流量的核心场景,例如秒杀(即突发流量控制在系统容量可以承受的范围),消息削峰填谷,集群流量控制,实时熔断下游不可用应用等
完美的实时监控:  Sentinel同事提供实时的监控功能,您可以在控制台看到接入应用的单台机器秒级数据,甚至500台一下规模的集群的汇总运行情况
广泛的开源生态:  Sentinel提供开箱即用的与其他框架/库的整合模块,例如与SpringCloud,Dubbo,gRPC的整合,您只需要引入响应的依赖并进行简单的配置即可快速接入Sentinel.
完美的SPI扩展点: Sentinel提供简单易用的,完美的SPI扩展接口,可以通过实现扩展接口来快速定制逻辑,例如定制规则管理,适配动态数据源等.
```
* Sentinel 的主要工作机制如下
```
对主流框架提供适配或者显示的 API，来定义需要保护的资源，并提供设施对资源进行实时统计和调用链路分析。
根据预设的规则，结合对资源的实时统计信息，对流量进行控制。同时，Sentinel 提供开放的接口，方便您定义及改变规则。
Sentinel 提供实时的监控系统，方便您快速了解目前系统的状态。
```

* sentinel规则数据持久化的四种方案
```
1、Nacos分布式配置中心：有界面，也不用重启服务器，推荐

A.添加maven坐标,将规则持久化进nacos
         <dependency>
            <groupId>com.alibaba.csp</groupId>
            <artifactId>sentinel-datasource-nacos</artifactId>
        </dependency>
B，修改yml,将nacos配置文件对应

sentinel:
      transport:
        dashboard: 127.0.0.1:8080
        port: 8719 #默认就是8719 如果被占用默认+1
      datasource:
        ds1:
          nacos:
            server-addr: 192.168.10.37:18848
            dataId: ${spring.application.name}
            groupId: DEV
            namespace: 8622d428-0496-4a09-b178-da3cfc736055
            data-type: json
            rule-type: flow
C，配置nacos文件

[
    {
        "resource":"testB",
        "limitAPP":"default",
        "grade":1,
        "count":1,
        "strategy":0,
        "controlBehavior":0,
        "clusterMode":false
    }

]
resource: 资源名称 limitApp: 来源应用 grade: 阈值类型, 0表示线程数,1表示QPS count: 单机阈值 strategy: 流控模式,0表示直接,1表示关联,2表示链路 controlBehavior: 流控效果,0表示快速失败,1表示WarmUp,2表示排队等待 clusterMode: 是否集群
```
```
2、携程阿波罗：有界面，也不用重启服务器，推荐
```
```
3、ZK，没有界面，不推荐
```
```
4、存放在本地文件：默认的，数据容易数据不一致，不推荐？

配置的限流在服务器重启后规则会被清空

Sentinel启动的时候读取naocs上的流控规则到内存中

整合nacos只要yml配置一下就好了，规则都写在nacos上，整合之后不能自己在代码里去配置流控规则，否则会覆盖nacos上的规则

```

* run
```
docker run --name sentinel -d  -p 8858:8858  bladex/sentinel-dashboard:1.7.2
```
