
- iptables

- - 一个定义规则的工具

  - - 让在内核空间当中的netfilter读取这些规则

    - - 从而实现防火墙功能

  - 功能点

  - - 流量均衡

    - 端口转发

    - - 将原本到某主机端口的数据包

      - - 转发给其他主机    

- 监控路径：      

- - 1.内核空间中：

  - - 从 一个网络接口进来
    - 到另一个网络接口去      

  - 2.数据包从内核流入用户空间的    

  - 3.数据包从用户空间流出的      

  - 4.进入/离开本机的外网接口     

  - 5.进入/离开本机的内网接口

- netfilter是Linux操作系统核心层内部的一个数据模块

- Hook point (5条链)

- - 数据包在Netfilter中的挂载点

  - 数据包在网络层会经过挂载点

  - - 就有机会对数据包做操作处理



- 目录

- - /sbin/iptables
```
规则组成
四张表filter表默认表
过滤nat表修改源、目标或端口mangle表指定如何处理数据包raw表状态跟踪处理异常
五张链PRE_ROUTING(路由前)INPUT(数据包流入口)FORWARD(转发关卡)OUTPUT(数据包流出口)POST_ROUTING（路由后）规则数据包访问控制：ACCEPTDROPREJECTLOG数据包改写：SNATDNAT!

**优先顺序**
**raw——mangle——nat——filter**

iptables防攻击cc的模块
connlimit模块限制每个IP并发连接数 主要是限制内网用户limit模块限速
SNAT：源地址转换技术让多个内网用户通过一个外网地址上网并能正常接受反馈数据DNAT：目的地址转换技术让外网IP能访问局域网内不同的服务器
iptables命令（规则）
没指定规则表默认为filter表不指定规则链则指表内所有规则链匹配会按照顺序由上往下匹配规则保证允许规则在拒绝规则之上
```

- 常见命令
**删除已有规则****
`iptables -F``iptables --flush`
`删除指定行数的规则`
`\**iptables -D INPUT 行号\**`
**查看现有规则
iptables -L
iptables -Lnv --line-number-v 
输出详细信息
iptables --list

查看表规则 （**raw—mangle—nat—filter**）
iptables -t nat --list   
永久生效**Ubuntu**iptables-save > /etc/iptables.rules
然后新建一个bash脚本，并保存到（unroot）/etc/network/if-pre-up.d/
（root）/etc/rc.d/rc.localiptables-restore < /etc/iptables.rules
注意：不要尝试在.bashrc或者.profile中执行以上命令，因为用户通常不是root，而且这只能在登录时加载iptables规则。

**CentOS**service iptables save/etc/sysconfig/iptables  
iptables [-t 表名] 选项 [链名] [条件] [-j 控制类型]

iptables -t nat -A  DOCKER -p tcp --dport 50070 -j DNAT --to-destination 172.17.0.4:50070  

