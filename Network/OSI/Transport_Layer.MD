
- 传输层 

- - 跨越通信子网

  - 端到端传送

  - 面向连接的传输服务 

  - - ATM
    - X.25
    - FR

  - 无连接的传输服务   

  - - UDP

  - **TPDU 传送协议数据单元Transport Protocol Data Unit**

  - - 在tcp中叫

    - - segment帧  

    - 在UDP中叫

    - - datagram报文

- **TCP 传输控制协议**

- - **TCP头格式**   

  - - TCP的包是没有IP地址的

    - - 那是IP层上的事

      - - 但是有源端口和目标端口

    - 一个TCP连接

    - - 需要四个元组来表示是同一个连接（src_ip, src_port, dst_ip, dst_port）准确说是五元组

      - 还有一个是协议

      - - 但因为这里只是说TCP协议，这里我只说四元组。

    - 四个非常重要的东西

      - **Sequence Number**是包的序号

      - - **用来解决网络包乱序（reordering）问题**

      - **Acknowledgement Number**就是ACK

      - - 用于确认收到

      - **Window又叫Advertised-Window**

      - - 也就是著名的滑动窗口（Sliding Window）

        - **用于解决流控的**

        - **TCP Flag** 

        - - 也就是包的类型
          - **主要是用于操控TCP的状态机的**

  - TCP数据流的切割与答复复原

  - **TCP连接的状态转换**

  - - - 11个状态   

      - - TIME_WAIT--30秒（2个MSL，MAX Segment Life）--CLOSED

      - **对称释放**   

      - - 每个方向的连接单独释放

        - - 两个方向互不影响

          - - 可避免数据丢失

      - **非对称释放** 

      - - 连接任一方都可断开连接

        - - 可能导致数据丢失

  - TCP状态机

  - - **对于建链接的3次握手**

    - - 主要是要初始化Sequence Number 的初始值

      - - 通信的双方要互相通知对方自己的初始化的Sequence Number

      - 全称Synchronize Sequence Numbers-SYN

      - - 这个号要作为以后的数据通信的序号

      - 以保证应用层接收到的数据不会因为网络上的传输的问题而乱序

      - - TCP会用这个序号来拼接数据

    - **对于4次挥手**

    - - 因为TCP是全双工的

      - - 发送方和接收方都需要Fin和Ack

        - - 只不过有一方是被动的

          - - 所以看上去就成了所谓的4次挥手

      - 如果两边同时断连接

      - - 那就会就进入到CLOSING状态

        - - 然后到达TIME_WAIT状态

  - 套接口socket

  - - tcp使用‘连接’而不仅仅是‘端口’

    - - TCP连接的端点

  - **数据复合** Multiplexing    

  - - 不同进程经由传输层给网络来传输的过程

  - **数据分离** Demultiplexing  

  - - 数据从网络层交付给不同进程的过程  

  - TCP Client-Server交互流程

  - UDP Client-Server交互流程

- **UDP 用户数据包协议 User Datagram Protocol**

- - 无连接

  - - 无交付确认

    - - 无拥塞

      - - 无差错控制

  - 伪首部仅仅为计算检验和

  - 它只是在IP协议上加入端口寻址能力

  - UDP协议传输消息

  - 基于端口的进程间通信

  - **使用UDP应用协议**

  - - DNS(**53**) 
    - **RPC**（Remote Procedure Call）远程过程调用协议
    - TFTP(**69**) 
    - BOOTP
    - DHCP(**67**) 
    - NTP123 
    - IP电话 
    - SNMP(161)

  - 协议树形图

- HTTPS

- - **SSL**  **安全套接层**   

  - - **加密Http请求**

  - **TLS** **传输层安全性**  

  - - **提供了客户机与服务器之间的安全连接**

- TCP/IP总体数据流

- 差错控制

- - **Go Back N (ARQ协议)**  

  - 利用差错检测技术自动的对丢失和错误帧请求重发

  - 停等ARQ

  - 发送站发送一帧必须等待应答信号ACK

  - - 收到信号后才能发送下一帧

    - - 如果收到否定应答信号NAK后重发该帧

      - - 如果在一定时间内未收到应答信号必须重发

  - 连续ARQ

  - - 选择重发ARQ

    - - 只重发出错的帧

      - - 后面的帧被缓存

      - 这种协议窗口大小的最大值应为帧编号数的一半 

      - - 2K-1

    - 后退N帧ARQ   

    - - 从出错处重发已发过的N个帧其窗口大小为W<=2K-1

- **Congestion avoidance 拥塞避免** 

- - **Sliding Window 滑动窗口协议**

  - - 如果接收端维持能容纳W个帧的缓冲区（即窗口大小为W）

    - - 那么发送端可以连续发送W个帧而不必等待应答信号

      - - 但在收到接收端的应答信号前

        - - 则滑动窗口不滑动

    - 接收端收到一个帧时

    - - 就发送一个应答信号

      - - 并把滑动窗口滑动到i=W-i+1的位置

        - - 表明i之前的已正确接收

          - - 期待接收后续W个帧

            - - 则线路利用率

  - **Slow-Start 慢启动**  

- **关于建连接时SYN超时**

- - 如果server端接到了clien发的SYN后回了SYN-ACK后client掉线了

  - - server端没有收到client回来的ACK

    - - 这个连接处于一个中间状态，即没成功，也没失败。

      - - server端如果在一定时间内没有收到的TCP会重发SYN-ACK。

    - 在Linux下默认重试次数为5次

    - - 重试的间隔时间从1s开始每次都翻售

      - - 5次的重试时间间隔为1s, 2s, 4s, 8s, 16s，总共31s

        - - 第5次发出后还要等32s都知道第5次也超时了

          - 总共需要 1s + 2s + 4s+ 8s+ 16s + 32s = 2^6 -1 = 63s

          - - TCP才会把断开这个连接

- **关于SYN Flood攻击**

- - 给服务器发了一个SYN后就下线了

  - - 于是服务器需要默认等63s才会断开连接

    - - 攻击者就可以把服务器的syn连接的队列耗尽，让正常的连接请求不能处理。

    - Linux下给了一个叫**tcp_syncookies**的参数来应对这个事

    - - 当SYN队列满了后

      - - TCP会通过源地址端口、目标地址端口和时间戳打造出

        - - 一个特别的Sequence Number发回去（又叫cookie）

      - 如果是攻击者则不会有响应

      - 如果是正常连接

      - - 则会把这个 SYN Cookie发回来

        - - 然后服务端可以通过cookie建连接（即使你不在SYN队列中）

    - **请先千万别用tcp_syncookies来处理正常的大负载的连接的情况**

    - - 因为synccookies是妥协版的TCP协议，并不严谨

    - 对于正常的请求应该调整三个TCP参数

    - - tcp_synack_retries 

      - - 可以用他来减少重试次数

      - tcp_max_syn_backlog

      - - 可以增大SYN连接数

      - tcp_abort_on_overflow 

      - - 处理不过来干脆就直接拒绝连接了

- **关于ISN的初始化**

- - ISN是不能hard code的

  - 如果连接建好后始终用1来做ISN

  - 如果client发了30个segment过去

  - - 但是网络断了

    - - 于是 client重连

      - - 又用了1做ISN

        - - 但是之前连接的那些包到了

          - - 于是就被当成了新连接的包

            - - 此时client的Sequence Number 可能是3

              - 而Server端认为client端的这个号是30了

              - - 全乱了

  - [RFC793](http://tools.ietf.org/html/rfc793)中说

  - - ISN会和一个假的时钟绑在一起

    - - 这个时钟会在每4微秒对ISN做加一操作

      - - 直到超过2^32又从0开始

    - 这样一个ISN的周期大约是4.55个小时

    - 假设我们的TCP Segment在网络上的存活时间不会超过MSL

    - - 所以只要MSL的值小于4.55小时

      - - 那么我们就不会重用到ISN

- **关于 MSL 和 TIME_WAIT**

- - 通过上面的ISN的描述，相信你也知道MSL是怎么来的了

  - 从TIME_WAIT状态到CLOSED状态

  - - 这个超时设置是 2*MSL

    - - （[RFC793](http://tools.ietf.org/html/rfc793)定义了MSL为2分钟，Linux设置成了30s）

    - 为什么要这有TIME_WAIT？

    - 为什么不直接给转成CLOSED状态呢？

    - 主要有两个原因：

    - - TIME_WAIT确保有足够的时间让对端收到了ACK

      - - 如果被动关闭的那方没有收到Ack

        - - 就会触发被动端重发Fin

          - - 一来一去正好2个MSL

      - 有足够的时间让这个连接不会跟后面的连接混在一起

      - - 有些自做主张的路由器会缓存IP数据包

        - - 如果连接被重用了

          - - 那么这些延迟收到的包就有可能会跟新连接混在一起

  - 你可以看看这篇文章

  - - 《[TIME_WAIT and its design implications for protocols and scalable client server systems](http://www.serverframework.com/asynchronousevents/2011/01/time-wait-and-its-design-implications-for-protocols-and-scalable-servers.html)》

- **关于TIME_WAIT数量太多**

- - TIME_WAIT是个很重要的状态

  - - 但是如果在大并发的短链接下TIME_WAIT 就会太多

    - - 这也会消耗很多系统资源

      - 十有八九的处理方式都是教你设置两个参数

      - - 这两个参数默认值都是被关闭的

        - **tcp_tw_reuse**

        - - **必需设置tcp_timestamps=1，否则无效**

        - **tcp_tw_recycle**的参数

        - **打开这两个参数会有比较大的坑**

        - - **可能会让TCP连接出一些诡异的问题**

          - - 如果不等待超时重用连接的话

            - - 新的连接可能会建不上

        - 正如[官方文档](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)上说的一样

        - - **It should not be changed without advice/request of technical experts**

- - **关于tcp_tw_reuse**

  - - 官方文档上说tcp_tw_reuse 加上tcp_timestamps（又叫PAWS, for Protection Against Wrapped Sequence Numbers）

    - - 可以保证协议的角度上的安全

      - - 但是你需要tcp_timestamps在两边都被打开（你可以读一下[tcp_twsk_unique](http://lxr.free-electrons.com/ident?i=tcp_twsk_unique)的源码 ）

- - **关于tcp_tw_recycle**

  - - 如果是tcp_tw_recycle被打开了话

    - - 会假设对端开启了tcp_timestamps

      - - 然后会去比较时间戳

        - - 如果时间戳变大了

          - - 就可以重用

            - 但是如果对端是一个NAT网络的话（如：一个公司只用一个IP出公网）

            - 或是对端的IP被另一台重用了

            - - 这个事就复杂了

              - - 建链接的SYN可能就被直接丢掉了

    - （你可能会看到connection time out的错误）

    - （如果你想观摩一下Linux的内核代码，请参看源码[ tcp_timewait_state_process](http://lxr.free-electrons.com/ident?i=tcp_timewait_state_process)）

- - **关于tcp_max_tw_buckets**

  - - 这个是控制并发的TIME_WAIT的数量

    - 默认值是180000

    - - 如果超限

      - - 那么系统会把多的给destory掉

        - - 然后在日志里打一个警告

          - - （如：time wait bucket table overflow

    - 官网文档说这个参数是用来对抗DDoS攻击的

    - - 也说的默认值180000并不小

      - - 这个还是需要根据实际情况考虑

- TIME_WAIT表示的是你主动断连接

- - 如果让对端断连接

  - - 那么这个破问题就是对方的了

  - 如果你的服务器是于HTTP服务器

  - - 那么设置一个[HTTP的KeepAlive](http://en.wikipedia.org/wiki/HTTP_persistent_connection)有多重要

    - - 浏览器会重用一个TCP连接来处理多个HTTP请求

      - - 然后让客户端去断链接

      - 要小心浏览器可能会非常贪婪

      - - 他们不到万不得已不会主动断连接

#### 数据传输中的Sequence Number 

#### 	**SeqNum的增加是和传输的字节数相关的**三次握手后来了两个Len:1440的包而第二个包的SeqNum就成了1441然后第一个ACK回的是1441表示第一个1440收到了
