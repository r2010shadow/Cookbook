**---引入**

Socket的英文原义是“孔”或“插座”，在Unix的进程通信机制中又称为‘套接字’。套接字实际上并不复杂，它是由一个ip地址以及一个端口号组成。Socket正如其英文原意那样，像一个多孔插座。一台主机犹如布满各种插座（ip地址）的房间，每个插座有很多插口（端口），通过这些插口接入电线（进程）我们可以烧水，看电视，玩电脑……  

应用程序通常通过"套接字"向网络发出请求或者应答网络请求。

套接字的作用之一就是用来区分不同应用进程，当某个进程绑定了本机ip的某个端口，那么所有传送至这个ip地址上的这个端口的所有数据都会被内核送至该进程进行处理。

**---python中的socket**

**Python** 提供了两个基本的 socket 模块。

  第一个是 Socket，它提供了标准的 BSD Sockets API。

  第二个是 SocketServer， 它提供了服务器中心类，可以简化网络服务器的开发。

**----socket**

  先来说第一个。

我们知道，现在的应用程序大多为C/S架构，也就是分为客户端/服务器端。

　　服务器端：服务器端进程需要申请套接字，然后自己绑定在这个套接字上，并对这个套接字进行监听。当有客户端发送数据了，则接受数据进行处理，处理完成后对客户端进行响应。

　　客户端：客户端则相对简单些，客户端只需要申请一个套接字，然后通过这个套接字连接服务器端的套接字，连接建立后就可以进行后续操作了。

**python编写服务器端的步骤：**

 1 创建套接字


```
import socket
s1=socket.socket(family,type)
#family参数代表地址家族，可为AF_INET或AF_UNIX。AF_INET家族包括Internet地址，AF_UNIX家族用于同一台机器上的进程间通信。
#type参数代表套接字类型，可为SOCK_STREAM(流套接字，就是TCP套接字)和SOCK_DGRAM(数据报套接字，就是UDP套接字)。 
#默认为family=AF_INET  type=SOCK_STREM    
#返回一个整数描述符，用这个描述符来标识这个套接字
```


 2 绑定套接字

```
s1.bind( address ) 
#由AF_INET所创建的套接字，address地址必须是一个双元素元组，格式是(host,port)。host代表主机，port代表端口号。
#如果端口号正在使用、主机名不正确或端口已被保留，bind方法将引发socket.error异常。 
#例: ('192.168.1.1',9999)
```

 3 监听套接字

```
s1.listen( backlog ) 
#backlog指定最多允许多少个客户连接到服务器。它的值至少为1。收到连接请求后，这些请求需要排队，如果队列满，就拒绝请求。 
```

 4 等待接受连接


```
connection, address = s1.accept()
#调用accept方法时，socket会时入“waiting”状态，也就是处于阻塞状态。客户请求连接时，方法建立连接并返回服务器。
#accept方法返回一个含有两个元素的元组(connection,address)。
#第一个元素connection是所连接的客户端的socket对象（实际上是该对象的内存地址），服务器必须通过它与客户端通信；
#第二个元素 address是客户的Internet地址。
```


 5 处理阶段


```
connection.recv(bufsize[,flag])
#注意此处为connection
#接受套接字的数据。数据以字符串形式返回，bufsize指定最多可以接收的数量。flag提供有关消息的其他信息，通常可以忽略

connection.send(string[,flag])
#将string中的数据发送到连接的套接字。返回值是要发送的字节数量，该数量可能小于string的字节大小。即：可能未将指定内容全部发送。
```


 6 传输结束，关闭连接

```
s1.close()
#关闭套接字
```

**python编写客户端**

 1 创建socket对象

```
import socket
s2=socket.socket()
```

 2 连接至服务器端

```
s2.connect(address)
#连接到address处的套接字。一般，address的格式为元组（hostname,port）,如果连接出错，返回socket.error错误。
```

 3 处理阶段


```
s2.recv(bufsize[,flag])
#接受套接字的数据。数据以字符串形式返回，bufsize指定最多可以接收的数量。flag提供有关消息的其他信息，通常可以忽略

s2.send(string[,flag])
#将string中的数据发送到连接的套接字。返回值是要发送的字节数量，该数量可能小于string的字节大小。即：可能未将指定内容全部发送。
```


 4 连接结束，关闭套接字

```
s2.close()
```

socket中还有许多方法 ：

 
```
socket.getaddrinfo(host, port, family=0, type=0, proto=0, flags=0) #获取要连接的对端主机地址

sk.bind(address)
  将套接字绑定到地址。address地址的格式取决于地址族。在AF_INET下，以元组（host,port）的形式表示地址。

sk.listen(backlog)
  开始监听传入连接。backlog指定在拒绝连接之前，可以挂起的最大连接数量。
  backlog等于5，表示内核已经接到了连接请求，但服务器还没有调用accept进行处理的连接个数最大为5，这个值不能无限大，因为要在内核中维护连接队列

sk.setblocking(bool)
  是否阻塞（默认True），如果设置False，那么accept和recv时一旦无数据，则报错。

sk.accept()
  接受连接并返回（conn,address）,其中conn是新的套接字对象，可以用来接收和发送数据。address是连接客户端的地址。接收TCP 客户的连接（阻塞式）等待连接的到来

sk.connect(address)
  连接到address处的套接字。一般，address的格式为元组（hostname,port）,如果连接出错，返回socket.error错误。

sk.connect_ex(address)
  同上，只不过会有返回值，连接成功时返回 0 ，连接失败时候返回编码，例如：10061

sk.close()
  关闭套接字

sk.recv(bufsize[,flag])
  接受套接字的数据。数据以字符串形式返回，bufsize指定最多可以接收的数量。flag提供有关消息的其他信息，通常可以忽略。

sk.recvfrom(bufsize[.flag])
  与recv()类似，但返回值是（data,address）。其中data是包含接收数据的字符串，address是发送数据的套接字地址。

sk.send(string[,flag])
  将string中的数据发送到连接的套接字。返回值是要发送的字节数量，该数量可能小于string的字节大小。即：可能未将指定内容全部发送。

sk.sendall(string[,flag])
  将string中的数据发送到连接的套接字，但在返回之前会尝试发送所有数据。成功返回None，失败则抛出异常。内部通过递归调用send，将所有内容发送出去。

sk.sendto(string[,flag],address)
  将数据发送到套接字，address是形式为（ipaddr，port）的元组，指定远程地址。返回值是发送的字节数。该函数主要用于UDP协议。

sk.settimeout(timeout)
  设置套接字操作的超时期，timeout是一个浮点数，单位是秒。值为None表示没有超时期。一般，超时期应该在刚创建套接字时设置，
  因为它们可能用于连接的操作（如 client 连接最多等待5s ）

sk.getpeername()
  返回连接套接字的远程地址。返回值通常是元组（ipaddr,port）。

sk.getsockname()
  返回套接字自己的地址。通常是一个元组(ipaddr,port)

sk.fileno()
  套接字的文件描述符

socket.sendfile(file, offset=0, count=None)
  发送文件 
```
 

好了，介绍完socket现在该介绍socketserver了。

**----socketserver**

　　虽说用Python编写简单的网络程序很方便，但复杂一点的网络程序还是用现成的框架比较  好。这样就可以专心事务逻辑，而不是套接字的各种细节。SocketServer模块简化了编写网络服务程序的任务。同时SocketServer模块也 是Python标准库中很多服务器框架的基础。

socketserver在python2中为SocketServer,在python3种取消了首字母大写，改名为socketserver。

socketserver中包含了两种类，一种为服务类（server class），一种为请求处理类（request handle class）。前者提供了许多方法：像绑定，监听，运行…… （也就是建立连接的过程） 后者则专注于如何处理用户所发送的数据（也就是事务逻辑）。

　　一般情况下，所有的服务，都是先建立连接，也就是建立一个服务类的实例，然后开始处理用户请求，也就是建立一个请求处理类的实例。

 

我们分析一下源码，来看一看服务类是如何与请求处理类建立联系的。


```
class BaseServer:
#我们创建服务类时，需要指定（地址，端口）,服务处理类。
    def __init__(self, server_address, RequestHandlerClass):
        """Constructor.  May be extended, do not override."""
        self.server_address = server_address
        self.RequestHandlerClass = RequestHandlerClass
        self.__is_shut_down = threading.Event()
        self.__shutdown_request = False
#…………此处省略n多代码，当我们执行server_forever方法时，里面就会调用很多服务类中的其他方法，但最终会调用finish_request方法。

    def finish_request(self, request, client_address):
        """Finish one request by instantiating RequestHandlerClass."""
        self.RequestHandlerClass(request, client_address, self)
#finish_request方法中执行了self.RequestHandlerClass(request, client_address, self)。self.RequestHandlerClass是什么呢？
#self.RequestHandlerClass = RequestHandlerClass（就在__init__方法中）。所以finish_request方法本质上就是创建了一个服务处理实例。


class BaseRequestHandler:
    def __init__(self, request, client_address, server):
        self.request = request
        self.client_address = client_address
        self.server = server
        self.setup()
        try:
            self.handle()
        finally:
            self.finish()
#当我们创建服务处理类实例时，就会运行handle()方法，而handle()方法则一般是我们处理事务逻辑的代码块。
#…………此处省略n多代码
```


我们接下来介绍一下这两个类

**先来看服务类：**

5种类型：BaseServer，TCPServer，UnixStreamServer，UDPServer，UnixDatagramServer。

BaseServer不直接对外服务。

TCPServer针对TCP套接字流

UDPServer针对UDP数据报套接字

UnixStreamServer和UnixDatagramServer针对UNIX域套接字，不常用。

他们之间的继承关系：


 

服务类的方法：

```
     class SocketServer.BaseServer：这是模块中的所有服务器对象的超类。它定义了接口，如下所述，但是大多数的方法不实现，在子类中进行细化。

    BaseServer.fileno()：返回服务器监听套接字的整数文件描述符。通常用来传递给select.select(), 以允许一个进程监视多个服务器。

    BaseServer.handle_request()：处理单个请求。处理顺序：get_request(), verify_request(), process_request()。如果用户提供handle()方法抛出异常，将调用服务器的handle_error()方法。如果self.timeout内没有请求收到， 将调用handle_timeout()并返回handle_request()。

    BaseServer.serve_forever(poll_interval=0.5): 处理请求，直到一个明确的shutdown()请求。每poll_interval秒轮询一次shutdown。忽略self.timeout。如果你需要做周期性的任务，建议放置在其他线程。

    BaseServer.shutdown()：告诉serve_forever()循环停止并等待其停止。python2.6版本。

    BaseServer.address_family: 地址家族，比如socket.AF_INET和socket.AF_UNIX。

    BaseServer.RequestHandlerClass：用户提供的请求处理类，这个类为每个请求创建实例。

    BaseServer.server_address：服务器侦听的地址。格式根据协议家族地址的各不相同，请参阅socket模块的文档。

    BaseServer.socketSocket：服务器上侦听传入的请求socket对象的服务器。

服务器类支持下面的类变量：

    BaseServer.allow_reuse_address：服务器是否允许地址的重用。默认为false ，并且可在子类中更改。

    BaseServer.request_queue_size

请求队列的大小。如果单个请求需要很长的时间来处理，服务器忙时请求被放置到队列中，最多可以放request_queue_size个。一旦队列已满，来自客户端的请求将得到 “Connection denied”错误。默认值通常为5 ，但可以被子类覆盖。

    BaseServer.socket_type：服务器使用的套接字类型; socket.SOCK_STREAM和socket.SOCK_DGRAM等。

    BaseServer.timeout：超时时间，以秒为单位，或 None表示没有超时。如果handle_request()在timeout内没有收到请求，将调用handle_timeout()。

下面方法可以被子类重载，它们对服务器对象的外部用户没有影响。

    BaseServer.finish_request()：实际处理RequestHandlerClass发起的请求并调用其handle()方法。 常用。

    BaseServer.get_request()：接受socket请求，并返回二元组包含要用于与客户端通信的新socket对象，以及客户端的地址。

    BaseServer.handle_error(request, client_address)：如果RequestHandlerClass的handle()方法抛出异常时调用。默认操作是打印traceback到标准输出，并继续处理其他请求。

    BaseServer.handle_timeout()：超时处理。默认对于forking服务器是收集退出的子进程状态，threading服务器则什么都不做。

    BaseServer.process_request(request, client_address) :调用finish_request()创建RequestHandlerClass的实例。如果需要，此功能可以创建新的进程或线程来处理请求,ForkingMixIn和ThreadingMixIn类做到这点。常用。

    BaseServer.server_activate()：通过服务器的构造函数来激活服务器。默认的行为只是监听服务器套接字。可重载。

    BaseServer.server_bind()：通过服务器的构造函数中调用绑定socket到所需的地址。可重载。

    BaseServer.verify_request(request, client_address)：返回一个布尔值，如果该值为True ，则该请求将被处理，反之请求将被拒绝。此功能可以重写来实现对服务器的访问控制。默认的实现始终返回True。client_address可以限定客户端，比如只处理指定ip区间的请求。 常用。
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.942343455680791.png)

这个几个服务类都是同步处理请求的：一个请求没处理完不能处理下一个请求。要想支持异步模型，可以利用多继承让server类继承ForkingMixIn 或 ThreadingMixIn mix-in classes。

ForkingMixIn利用多进程（分叉）实现异步。

ThreadingMixIn利用多线程实现异步。

 

**请求处理器类：**

要实现一项服务，还必须派生一个handler class请求处理类，并重写父类的handle()方法。handle方法就是用来专门是处理请求的。该模块是通过服务类和请求处理类组合来处理请求的。

SocketServer模块提供的请求处理类有BaseRequestHandler，以及它的派生类StreamRequestHandler和DatagramRequestHandler。从名字看出可以一个处理流式套接字，一个处理数据报套接字。

 

请求处理类有三种方法：

- **`setup`()**

  Called before the [`handle()`](https://docs.python.org/3.5/library/socketserver.html#socketserver.BaseRequestHandler.handle) method to perform any initialization actions required. The default implementation does nothing.也就是在handle()之前被调用，主要的作用就是执行处理请求之前的初始化相关的各种工作。默认不会做任何事。（如果想要让其做一些事的话，就要程序员在自己的请求处理器中覆盖这个方法（因为一般自定义的请求处理器都要继承python中提供的BaseRequestHandler，ps：下文会提到的），然后往里面添加东西即可）

- **`handle`()**

  This function must do all the work required to service a request. The  default implementation does nothing. Several instance attributes are  available to it; the request is available as `self.request`; the client address as `self.client_address`; and the server instance as `self.server`, in case it needs access to per-server information.The type of `self.request` is different for datagram or stream services. For stream services,`self.request` is a socket object; for datagram services, `self.request` is a pair of string and socket.handle()的工作就是做那些所有与处理请求相关的工作。默认也不会做任何事。他有数个实例参数：self.request  self.client_address  self.server

- **`finish`()**

  Called after the [`handle()`](https://docs.python.org/3.5/library/socketserver.html#socketserver.BaseRequestHandler.handle) method to perform any clean-up actions required. The default implementation does nothing. If [`setup()`](https://docs.python.org/3.5/library/socketserver.html#socketserver.BaseRequestHandler.setup) raises an exception, this function will not be called.在handle()方法之后会被调用，他的作用就是执行当处理完请求后的清理工作，默认不会做任何事

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.4443282326182303.png)

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.38244489626615374.png)

```
class BaseRequestHandler:

    """Base class for request handler classes.

    This class is instantiated for each request to be handled.  The
    constructor sets the instance variables request, client_address
    and server, and then calls the handle() method.  To implement a
    specific service, all you need to do is to derive a class which
    defines a handle() method.

    The handle() method can find the request as self.request, the
    client address as self.client_address, and the server (in case it
    needs access to per-server information) as self.server.  Since a
    separate instance is created for each request, the handle() method
    can define arbitrary other instance variariables.

    """

    def __init__(self, request, client_address, server):
        self.request = request
        self.client_address = client_address
        self.server = server
        self.setup()
        try:
            self.handle()
        finally:
            self.finish()

    def setup(self):
        pass

    def handle(self):
        pass

    def finish(self):
        pass


# The following two classes make it possible to use the same service
# class for stream or datagram servers.
# Each class sets up these instance variables:
# - rfile: a file object from which receives the request is read
# - wfile: a file object to which the reply is written
# When the handle() method returns, wfile is flushed properly


class StreamRequestHandler(BaseRequestHandler):

    """Define self.rfile and self.wfile for stream sockets."""

    # Default buffer sizes for rfile, wfile.
    # We default rfile to buffered because otherwise it could be
    # really slow for large data (a getc() call per byte); we make
    # wfile unbuffered because (a) often after a write() we want to
    # read and we need to flush the line; (b) big writes to unbuffered
    # files are typically optimized by stdio even when big reads
    # aren't.
    rbufsize = -1
    wbufsize = 0

    # A timeout to apply to the request socket, if not None.
    timeout = None

    # Disable nagle algorithm for this socket, if True.
    # Use only when wbufsize != 0, to avoid small packets.
    disable_nagle_algorithm = False

    def setup(self):
        self.connection = self.request
        if self.timeout is not None:
            self.connection.settimeout(self.timeout)
        if self.disable_nagle_algorithm:
            self.connection.setsockopt(socket.IPPROTO_TCP,
                                       socket.TCP_NODELAY, True)
        self.rfile = self.connection.makefile('rb', self.rbufsize)
        self.wfile = self.connection.makefile('wb', self.wbufsize)

    def finish(self):
        if not self.wfile.closed:
            try:
                self.wfile.flush()
            except socket.error:
                # An final socket error may have occurred here, such as
                # the local error ECONNABORTED.
                pass
        self.wfile.close()
        self.rfile.close()


class DatagramRequestHandler(BaseRequestHandler):

    # XXX Regrettably, I cannot get this working on Linux;
    # s.recvfrom() doesn't return a meaningful client address.

    """Define self.rfile and self.wfile for datagram sockets."""

    def setup(self):
        from io import BytesIO
        self.packet, self.socket = self.request
        self.rfile = BytesIO(self.packet)
        self.wfile = BytesIO()

    def finish(self):
        self.socket.sendto(self.wfile.getvalue(), self.client_address)
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.308871566946022.png)

从源码中可以看出，BaseRequestHandler中的setup()/handle()/finish()什么内容都没有定义，而他的两个派生类StreamRequestHandler和DatagramRequestHandler则都重写了setup()/finish()。

因此当我们需要自己编写socketserver程序时，只需要合理选择StreamRequestHandler和DatagramRequestHandler之中的一个作为父类，然后自定义一个请求处理类，并在其中重写handle()方法即可。

 

**用socketserver创建一个服务的步骤：**

1 创建一个request handler class（请求处理类），合理选择StreamRequestHandler和DatagramRequestHandler之中的一个作为父类（当然，使用BaseRequestHandler作为父类也可），并重写它的handle()方法。

2 实例化一个server class对象，并将服务的地址和之前创建的request handler class传递给它。

3 调用server class对象的handle_request() 或 serve_forever()方法来开始处理请求。

 **代码实例**：

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.24346383191439136.png)

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.44549398602544543.png)

```
import socketserver
 
class MyTCPHandler(socketserver.BaseRequestHandler):
    """
    The request handler class for our server.
 
    It is instantiated once per connection to the server, and must
    override the handle() method to implement communication to the
    client.
    """
 
    def handle(self):
        # self.request is the TCP socket connected to the client
        self.data = self.request.recv(1024).strip()
        print("{} wrote:".format(self.client_address[0]))
        print(self.data)
        # just send back the same data, but upper-cased
        self.request.sendall(self.data.upper())
 
if __name__ == "__main__":
    HOST, PORT = "localhost", 9999
 
    # Create the server, binding to localhost on port 9999
    server = socketserver.TCPServer((HOST, PORT), MyTCPHandler)
 
    # Activate the server; this will keep running until you
    # interrupt the program with Ctrl-C
    server.serve_forever()
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.41884464881157135.png)

![img](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.5316703371496574.png)

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.5653160387574008.png)

```
import socket
import sys
 
HOST, PORT = "localhost", 9999
data = " ".join(sys.argv[1:])
 
# Create a socket (SOCK_STREAM means a TCP socket)
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 
try:
    # Connect to server and send data
    sock.connect((HOST, PORT))
    sock.sendall(bytes(data + "\n", "utf-8"))
 
    # Receive data from the server and shut down
    received = str(sock.recv(1024), "utf-8")
finally:
    sock.close()
 
print("Sent:     {}".format(data))
print("Received: {}".format(received))
```

![复制代码](https://www.wiz.cn/xapp/ks/note/view/087a0673-171a-4ca9-a67b-1bb2f6b03e1f/5967ac48-fb71-4dd3-b3be-13539a3948c8/index_files/0.848566437037062.png)

 

 

no

来源： http://www.cnblogs.com/MnCu8261/p/5546823.html
