# Transmission Control Protocol


- TCP的包是没有IP地址的，那是IP层上的事。但是有源端口和目标端口。
- 一个TCP连接需要四个元组来表示是同一个连接（src_ip, src_port, dst_ip, dst_port）准确说是五元组，还有一个是协议。但因为这里只是说TCP协议，所以，这里我只说四元组。
- 注意上图中的四个非常重要的东西：
  - **Sequence Number**是包的序号，**用来解决网络包乱序（reordering）问题。**
  - **Acknowledgement Number**就是ACK——用于确认收到，**用来解决不丢包的问题**。
  - **Window又叫Advertised-Window**，也就是著名的滑动窗口（Sliding Window），**用于解决流控的**。
  - **TCP Flag** ，也就是包的类型，**主要是用于操控TCP的状态机的**。


* TCP的状态机
```
其实，网络上的传输是没有连接的，包括TCP也是一样的。而TCP所谓的“连接”，其实只不过是在通讯的双方维护一个“连接状态”，
让它看上去好像有连接一样。所以，TCP的状态变换是非常重要的。

下面是：“TCP协议的状态机”（图片来源） 和 “TCP建链接”、“TCP断链接”、“传数据” 的对照图，把两个图并排放在一起，对照着看。
```

<img src="https://github.com/r2010shadow/Cookbook/blob/master/Network/img/tcp_status.png" width=300 >

* 3次握手
```
对于建链接的3次握手，主要是要初始化Sequence Number 的初始值。通信的双方要互相通知对方自己的初始化的Sequence Number（缩写为ISN：Inital Sequence Number）——所以叫SYN，全称Synchronize Sequence Numbers。也就上图中的 x 和 y。这个号要作为以后的数据通信的序号，以保证应用层接收到的数据不会因为网络上的传输的问题而乱序（TCP会用这个序号来拼接数据）。
```
* 对于4次挥手
```
其实你仔细看是2次，因为TCP是全双工的，所以，发送方和接收方都需要Fin和Ack。只不过，有一方是被动的，所以看上去就成了所谓的4次挥手。如果两边同时断连接，那就会就进入到CLOSING状态，然后到达TIME_WAIT状态。
```

<img src="https://github.com/r2010shadow/Cookbook/blob/master/Network/img/TCP_34.png" width=300>
