# ntp.conf

- 1.时区 2.ntpdate 3.service
```
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
ntpdate time.windows.com && hwclock -w
rpm -qa | grep ntp
chkconfig ntpd on
service ntpd start 


1 * * * /usr/sbin/ntpdate pool.ntp.org; hwclock -w >/dev/null 2>&1
ntpdate time.windows.com && hwclock -w

NTP
yum install ntp -y
 ntpdate time.nist.gov 
*/10 * * * * ntpdate time.nist.gov
```

## ntpd、ntpdate的区别
```
使用之前得弄清楚一个问题，ntpd与ntpdate在更新时间时有什么区别。ntpd不仅仅是时间同步服务器，他还可以做客户端与标准时间服务器进行同步时间，而且是平滑同步，并非ntpdate立即同步，在生产环境中慎用ntpdate，也正如此两者不可同时运行。
时钟的跃变，对于某些程序会导致很严重的问题。许多应用程序依赖连续的时钟——毕竟，这是一项常见的假定，即，取得的时间是线性的，一些操作，例如数据库事务，通常会地依赖这样的事实：时间不会往回跳跃。不幸的是，ntpdate调整时间的方式就是我们所说的”跃变“：在获得一个时间之后，ntpdate使用settimeofday(2)设置系统时间，这有几个非常明显的问题：
第一，这样做不安全。ntpdate的设置依赖于ntp服务器的安全性，攻击者可以利用一些软件设计上的缺陷，拿下ntp服务器并令与其同步的服务器执行某些消耗性的任务。由于ntpdate采用的方式是跳变，跟随它的服务器无法知道是否发生了异常（时间不一样的时候，唯一的办法是以服务器为准）。
第二，这样做不精确。一旦ntp服务器宕机，跟随它的服务器也就会无法同步时间。与此不同，ntpd不仅能够校准计算机的时间，而且能够校准计算机的时钟。
第三，这样做不够优雅。由于是跳变，而不是使时间变快或变慢，依赖时序的程序会出错（例如，如果ntpdate发现你的时间快了，则可能会经历两个相同的时刻，对某些应用而言，这是致命的）。
因而，唯一一个可以令时间发生跳变的点，是计算机刚刚启动，但还没有启动很多服务的那个时候。其余的时候，理想的做法是使用ntpd来校准时钟，而不是调整计算机时钟上的时间。
NTPD 在和时间服务器的同步过程中，会把 BIOS 计时器的振荡频率偏差——或者说 Local Clock 的自然漂移(drift)——记录下来。这样即使网络有问题，本机仍然能维持一个相当精确的走时。
``` 
- ntp的移植
1)   ./configure --prefix=YOUR_INSTALL_DIRECTORY--host=arm-linux
2)   make
3)   make install
 
 
- ntp的使用
1)  在客户端上vi /etc/services 增加两行：
ntp          123/tcp
ntp          123/udp
 
2)  如果客户端/etc目录下没有localtime文件，将服务器上/etc目录下的localtime文件复制到客户端的/etc目录下
3)    打开时间服务器（假设其IP地址为192.168.1.11）上的ntp进程
/etc/init.d/ntp start
 
4)    客户端开始更新时间
ntpdate 192.168.1.11
注意：
l  如果重启ntp守护进程后，开发板有可能无法立即更新时间，提示错误“no server suitable for synchronization found”，这是因为每次重启NTP服务器之后大约要3－5分钟客户端才能与服务器建立正常的通讯连接，等待一会儿再更新就可以了。
l  有可能防火墙会阻碍更新时间，这时可以加上“-u”参数。
 
 
- ntp的配置
```
这方面的文章网上有很多，讲的也很详细，主要就是修改/etc/init.d/ntp.conf文件，我稍作了修改，加了两行：
server 210.72.145.44
server cn.pool.ntp.org
之后我就可以同步时间了，有人加了这么一行
restrict 192.168.1.1mask 255.255.255.0 nomodify
我没有加，但依然成功，看了下配置文件有这第一行
restrict ::1
可能这一行就包含那一行的意思吧！仅仅是猜测。下面给出一个样本加注释，仅供参考：
# 1. 关于权限设定部分 
#　　 权限的设定主要以 restrict 这个参数来设定，主要的语法为： 
# 　　restrict IP mask netmask_IP parameter 
# 　　其中 IP 可以是软件地址，也可以是 default ，default 就类似 0.0.0.0 
#　　 至于 paramter 则有： 
#　　　ignore　：关闭所有的 NTP 联机服务 
#　　　nomodify：表示 Client 端不能更改 Server 端的时间参数，不过，
#　　　Client 端仍然可以透过 Server 端来进行网络校时。 
#　　　notrust ：该 Client 除非通过认证，否则该 Client 来源将被视为不信任网域 
#　　　noquery ：不提供 Client 端的时间查询
#　　　notrap ：不提供trap这个远程事件登入
#　　如果 paramter 完全没有设定，那就表示该 IP (或网域)“没有任何限制”
restrict default nomodify notrap noquery　# 关闭所有的 NTP 要求封包 
restrict 127.0.0.1　　　 #这是允许本级查询
restrict 192.168.0.1 mask 255.255.255.0 nomodify 
#在192.168.0.1/24网段内的服务器就可以通过这台NTP Server进行时间同步了 
# 2. 上层主机的设定 
#　　要设定上层主机主要以 server 这个参数来设定，语法为：
#　　server [IP|HOST Name] [prefer]
#　　Server 后面接的就是我们上层 Time Server 啰！而如果 Server 参数 
#　　后面加上 perfer 的话，那表示我们的 NTP 主机主要以该部主机来作为 
#　　时间校正的对应。另外，为了解决更新时间封包的传送延迟动作， 
#　　所以可以使用 driftfile 来规定我们的主机 
#　　在与 Time Server 沟通时所花费的时间，可以记录在 driftfile  
#　　后面接的文件内，例如下面的范例中，我们的 NTP server 与  
#　　cn.pool.ntp.org联机时所花费的时间会记录在 /etc/ntp/drift文件内
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server cn.pool.ntp.org prefer
#其他设置值，以系统默认值即可
server  127.127.1.0     # localclock
fudge   127.127.1.0 stratum 10
driftfile /var/lib/ntp/drift
broadcastdelay  0.008
keys /etc/ntp/keys
总结一下，restrict用来设置访问权限，server用来设置上层时间服务器，driftfile用来设置保存漂移时间的文件。
``` 
 
- 不同机器之间的时间同步
```
为了避免主机时间因为长期运作下所导致的时间偏差，进行时间同步(synchronize)的工作是非常必要的。Linux系统下，一般使用ntp服务器来同步不同机器的时间。一台机器，可以同时是ntp服务器和ntp客户机。在网络中，推荐使用像DNS服务器一样分层的时间服务器来同步时间。 同步时间，可以使用ntpdate命令，也可以使用ntpd服务。 使用ntpdate比较简单。格式如下：
[root@linux ~]# ntpdate [-nv] [NTP IP/hostname]
[root@linux ~]# ntpdate 192.168.0.2
[root@linux ~]# ntpdate time.ntp.org
     但这样的同步，只是强制性的将系统时间设置为ntp服务器时间。如果cpu tick有问题，只是治标不治本。所以，一般配合cron命令，来进行定期同步设置。比如，在crontab中添加：
0 12 * * * */usr/sbin/ntpdate 192.168.0.1
      这样，会在每天的12点整，同步一次时间。ntp服务器为192.168.0.1。
       要注意的是，ntpd 有一个自我保护设置: 如果本机与上源时间相差太大, ntpd 不运行. 所以新设置的时间服务器一定要先 ntpdate 从上源取得时间初值, 然后启动 ntpd服务。ntpd服务 运行后, 先是每64秒与上源服务器同步一次, 根据每次同步时测得的误差值经复杂计算逐步调整自己的时间, 随着误差减小, 逐步增加同步的间隔. 每次跳动, 都会重复这个调整的过程.
```
 
- ntpd服务的设置
```
ntpd服务的相关设置文件如下：
1)    /etc/ntp.conf：这个是NTP daemon的主要设文件，也是 NTP 唯一的设定文件。
2)    /usr /share/zoneinfo/:在这个目录下的文件其实是规定了各主要时区的时间设定文件，例如北京地区的时区设定文件在/usr/share/zoneinfo/Asia/Beijing 就是了。这个目录里面的文件与底下要谈的两个文件(clock 与localtime)是有关系的。
3)    /etc/sysconfig/clock：这个文件其实也不包含在NTP 的 daemon 当中，因为这个是 linux 的主要时区设定文件。每次开机后，Linux 会自动的读取这个文件来设定自己系统所默认要显示的时间。
4)    /etc /localtime：这个文件就是“本地端的时间配置文件”。刚刚那个clock 文件里面规定了使用的时间设置文件(ZONE) 为/usr/share/zoneinfo/Asia/Beijing ，所以说，这就是本地端的时间了，此时， Linux系统就会将Beijing那个文件另存为一份 /etc/localtime文件，所以未来我们的时间显示就会以Beijing那个时间设定文件为准。
5)    /etc/timezone：系统时区文件
```  
 
- ntp服务的启动与观察
```
在启动NTP服务前，先对提供服务的这台主机手动的校正一次时间咯。（因为启动服务器，端口会被服务端占用，就不能手动同步时间了）
[root@linux ~] # ntpdate cn.pool.ntp.org
25 Apr 14:33:51 ntpdate[8310]: step time server80.85.129.2 offset 6.655976 sec
然后，启动ntpd服务：
 [root@linux ~] # /etc/init.d/ntp start /restart
查看端口：
[root@linux ~] # netstat -ln|grep 123
udp       0      0192.168.228.153:123        0.0.0.0:*
udp       0      0127.0.0.1:123              0.0.0.0:*
udp       0      00.0.0.0:123                 0.0.0.0:*
udp       0      0:::123                      :::*
``` 
 
- ntptrace
[root@linux ~] # ntptrace –n 127.0.0.1
127.0.0.1:stratum 11, offset 0.000000，synch distance0.950951
222.73.214.125：stratum 2，offset –0.000787，synch distance0.108575
209.81.9.7:stratum 1，offset 0.000028，synch distance0.00436，refid ‘GPS’
#这个指令可以列出目前NTP服务器（第一层）与上层NTP服务器（第二层）彼此之间的关系
 
 
- ntpq
```
[root@linux ~] # ntpq –p
指令“ntpq -p”可以列出目前我们的NTP与相关的上层NTP的状态，以上的几个字段的意义如下：
remote：即NTP主机的IP或主机名称。注意最左边的符号，如果由“+”则代表目前正在作用钟的上层NTP，如果是“*”则表示也有连上线，不过是作为次要联机的NTP主机。
refid：参考的上一层NTP主机的地址
st：即stratum阶层
when：几秒前曾做过时间同步更新的操作
poll：下次更新在几秒之后
reach：已经向上层NTP服务器要求更新的次数
delay：网络传输过程钟延迟的时间
offset：时间补偿的结果
jitter：Linux系统时间与BIOS硬件时间的差异时间
``` 
 
- 系统时间与硬件时间同步
ntp服务，默认只会同步系统时间。如果想要让ntp同时同步硬件时间，可以设置/etc/sysconfig/ntpd文件，
在/etc/sysconfig/ntpd文件中，添加 SYNC_HWCLOCK=yes 这样，就可以让硬件时间与系统时间一起同步。

