# /etc/resolv.conf文件详解
```
DNS客户机配置文件，用于设置DNS服务器的IP地址及DNS域名，还包含了主机的域名搜索顺序。
该文件是由域名解析器（resolver，一个根据主机名解析IP地址的库）使用的配置文件。它的格式很简单，每行以一个关键字开头，后接一个或多个由空格隔开的参数。

resolv.conf的关键字主要有四个，分别是：

nameserver  //定义DNS服务器的IP地址

domain    //定义本地域名

search     //定义域名的搜索列表

sortlist     //对返回的域名进行排序
```

- 示例
```
domain  51osos.com

search [www.51osos.com](http://www.51osos.com/) 51osos.com

nameserver 202.102.192.68

nameserver 202.102.192.69

最主要是nameserver关键字，如果没指定nameserver就找不到DNS服务器，其它关键字是可选的。

nameserver表示解析域名时使用该地址指定的主机为域名服务器。其中域名服务器是按照文件中出现的顺序来查询的,且只有当第一个nameserver没有反应时才查询下面的nameserver。

domain　　　声明主机的域名。很多程序用到它，如邮件系统；当为没有域名的主机进行DNS查询时，也要用到。如果没有域名，主机名将被使用，删除所有在第一个点( .)前面的内容。

search　　　它的多个参数指明域名查询顺序。当要查询没有域名的主机，主机将在由search声明的域中分别查找。

domain和search不能共存；如果同时存在，后面出现的将会被使用。

sortlist　　允许将得到域名结果进行特定的排序。它的参数为网络/掩码对，允许任意的排列顺序。

衔接上文

single-request-reopen参数
```
- 解析过程
```
在RHLE6/CENTOS6的环境里，需要在/etc/resolv.conf加如下参数

options single-request-reopen   # 注意全部是小写字母

原因说明： RHEL5/CentOS5/Ubuntu 10.04等等linux下，dns的解析请求过程如下。

[![【linux运维】centos6需启用single-request-reopen参数](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/2a5449dd-8046-44d6-afae-895916ba5bce/index_files/d0b1c072b39445a8efa8a45eac729988.png)](http://photo.blog.sina.com.cn/showpic.html#blogid=7f2122c50101uk9m&url=http://album.sina.com.cn/pic/002kll0pgy6JVcBZpB406)

1  主机从一个随机的源端口，请求 DNS的AAAA 记录，

2  主机接受dns服务器返回AAAA记录，

3  主机从一个另一个随机的源端口，请求 DNS的A 记录，

3  主机dns 服务器返回A记录，

如果是RHEL6/CentOS6，交互过程有所不同
1 主机从一个随机的源端口，请求 DNS的A 记录，
2 主机从同一个源端口，请求 DNS的AAAA 记录，
3 主机接受dns服务器返回A记录，
4 主机接受 dns服务器返回AAAA记录，

上面3,4并没有严格的先后顺序，实际的顺序受网络环境，服务器环境的影响。

理论上讲centos6的这种工作机制，效率更高，端口复用度更高，能节省更多的资源。

但是这里也同样存在着一个问题。比如在存在防火墙等机制的网络环境中，同样源目的ip,同样源目的port，
同样的第4层协议的连接会被防火墙看成是同一个会话，因此会存在返回包被丢弃现象。

此时的整个dns解析过程如下：

1 主机从一个随机的源端口，请求 DNS的A 记录，
2 主机从同一个源端口，请求 DNS的AAAA 记录，

3  主机先收到dns返回的AAAA记录，

4  防火墙认为本次交互通信已经完成，关闭连接，

5  于是剩下的dns服务器返回的A记录响应包被防火墙丢弃

6  等待5秒超时之后，主机因为收不到A记录的响应，重新通过新的端口发起A记录查询请求，此后的机制等同于centos5）

7  主机收到dns的A记录响应；

8  主机从另一个新的源端口发起AAAA

9  主机收到dns的AAAA记录响应；

我们看到在这个解析的序列里面，dns解析有5秒的延迟发生。所以当用linux系统安装大量远程包的时候宏观上看延迟就非常大了（linux是不缓存dns解析记录的）。

那么到底 options single-request-reopen  这个参数的作用是什么的，man 5 resolv,conf的结果如下

​       single-request-reopen (since glibc 2.9)

​           The resolver uses the same socket for the A and AAAA

​           requests.  Some hardware mistakenly sends back only one

​           reply.  When that happens the client system will sit

​           and wait for the second reply.  Turning this option on

​           changes this behavior so that if two requests from the

​           same port are not handled correctly it will close the

​           socket and open a new one before sending the second

​           request
```
