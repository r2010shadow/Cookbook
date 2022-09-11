# rsync
是类unix系统下的数据镜像备份工具，从软件的命名上就可以看出来了——remote sync。
```
它的特性如下：
可以镜像保存整个目录树和文件系统。
可以很容易做到保持原来文件的权限、时间、软硬链接等等。
无须特殊权限即可安装。
优化的流程，文件传输效率高。
可以使用rcp、ssh等方式来传输文件，当然也可以通过直接的socket连接。
支持匿名传输，以方便进行网站镜象。

```
- 软件下载
```
rysnc的主页地址为：
http://rsync.samba.org/

首先，检查rsync是否安装,如果没有需要手动安装
#检查是否安装过rsync，或者使用命令  rpm -qa|grep rsync 也可以

whereis rsync
#如果结果类似下面这张情况，则已经安装
# rsync: /usr/bin/rsync /usr/share/man/man1/rsync.1.gz

#如果结果是,那么说明当前服务器还没有安装过rsync
# rsync:

#使用yum安装rsync
yum install rsync

创建rsyncd服务的配置文件
默认安装后，在/etc目录下，并不存在rsyncd目录，需要手动创建配置文件目录
makdir /etc/rsyncd

在/etc/rsyncd目录下创建如下文件
touch /etc/rsyncd/rsyncd.conf          #主配置文件


touch /etc/rsyncd/rsyncd.secrets       #用户名密码文件，一组用户一行，用户名和密码使用 : 分割
touch /etc/rsyncd/rsyncd.motd          #非必须，连接上rsyncd显示的欢迎信息，此文件可不创建

必须注意的是，rsyncd服务的密码文件权限必须是600

chmod 0600 /etc/rsyncd/rsyncd.secrets
```
- 编辑主配置文件 rsyncd.conf
```
######################################################################################################
#                      ******进程相关全局配置******
######################################################################################################
# = 后面的值可根据自己的实际情况更改
#    pid file 守护进程pid文件
#    port 守护进程监听端口，可更改，由xinetd允许rsyncd时忽略此参数
#    address 守护进程监听ip，由xinetd允许rsyncd时忽略此参数
pid file = /usr/local/var/run/rsyncd.pid
port = 873
address = 192.168.1.2
#rsyncd 守护进程运行系统用户全局配置，也可在具体的块中独立配置,
uid = root
gid = root
#允许 chroot，提升安全性，客户端连接模块，首先chroot到模块path参数指定的目录下
#chroot为yes时必须使用root权限，且不能备份path路径外的链接文件
use chroot = yes
#只读
read only = no
#只写
write only = no

#允许访问rsyncd服务的ip，ip端或者单独ip之间使用空格隔开
hosts allow = 192.168.0.1/255.255.255.0 198.162.145.1 10.0.1.0/255.255.255.0

#不允许访问rsyncd服务的ip，*是全部(不涵盖在hosts allow中声明的ip，注意和hosts allow的先后顺序)
hosts deny = *

#客户端最大连接数
max connections = 5

#欢迎文件路径，可选的
#motd file = /etc/rsyncd/rsyncd.motd

#日志相关
#    log file 指定rsync发送消息日志文件，而不是发送给syslog，如果不填这个参数默认发送给syslog
#    transfer logging 是否记录传输文件日志
#    log format 日志文件格式，格式参数请google
#    syslog facility rsync发送消息给syslog时的消息级别，
#    timeout连接超时时间
log file = /usr/local/logs/rsyncd.log
transfer logging = yes
log format = %t %a %m %f %b
syslog facility = local3
timeout = 300

######################################################################################################
#                      ******模块配置(多个)******
######################################################################################################
#模块 模块名称必须使用[]环绕，比如要访问data1,则地址应该是data1user@192.168.1.2::data1

[data1]
#模块根目录，必须指定
path=/home/username

#是否允许列出模块里的内容
list=yes

#忽略错误
#ignore errors

#模块验证用户名称，可使用空格或者逗号隔开多个用户名
auth users = data1user

#模块验证密码文件 可放在全局配置里
secrets file=/etc/rsyncd/rsyncd.secrets

#注释
comment = some description about this moudle

#排除目录，多个之间使用空格隔开
exclude = test1/ test2/

可以直接copy上述内容，作为自己rsyncd服务的配置模板
```

- 启动rsyncd服务
```
rsyncd 服务负载比较高的时候，设定rsyncd为独立的守护进程
#默认配置文件是/etc/rsyncd.conf，所以需要显式的指定配置文件
/usr/bin/rsync --daemon --config=/etc/rsyncd/rsyncd.conf
#假设使用putty，xshell终端操作,保证终端断开进程仍然执行
nohup /usr/bin/rsync --daemon --config=/etc/rsyncd/rsyncd.conf
为了保证开机时自动启动，需要手动加上面的命令(/usr/bin/rsync --daemon --config=/etc/rsyncd/rsyncd.conf)加入 /etc/rc.local 文件中 如果服务器开启了防火墙，必须保证端口能穿过防火墙
iptables -A INPUT -p tcp -m state --state NEW  -m tcp --dport 873 -j ACCEPT  
端口号修改为实际端口号即可
rsyncd 使用xinetd运行
xinetd的rsync配置文件是/etc/xinetd.d/rsync
需要编辑此文件修改一个参数,显式的指定rsyncd服务的配置文件
server_args     = --daemon --config=/etc/rsyncd/rsyncd.conf 
注意系统如果没有安装xinetd，需要 yum intall xinetd
chkconfig rsync on  
service xinetd restart
```
- 使用rsync传输数据
```
示例1:  
rsync -avzP data1user@192.168.1.2::data1 ~/data1
保持传输原有文件权限，用户，用户组，时间，递归的把data1模块数据复制到用户家目录的data1目录里，
参数 a的意思就是 保留文件原有权限，用户，用户组，时间且递归的copy包括链接文件，块设备在内的所有文件，这个参数很常用
参数 v是显示传输信息
参数 P显示传输进度
参数 z是压缩传输内容进行传输
假设要保持data1模块和用户家目录模块内容完全一致,加上参数 --delete,这样会删除在~/data1目录里但是不在data1模块里的文件(夹)
rsync -avzP --delete data1user@192.168.1.2::data1 ~/data1
示例2：
rsync -avzP --delete --password-file=/~/rsync/data1.secrets data1user@192.168.1.2::data1 ~/data1
传输时自动使用密码文件而不用手动输入，注意密码文件权限必须是600
```

- Rsync同步算法
```
Rsync只所以同步文件的速度相当快，是因为“Rsync同步算法”能在很短的时间内计算出需要备份的数据，
关于Rsync的同步算法描述如下：
假定在1号和2号两台计算机之间同步相似的文件A与B，其中1号对文件A拥有访问权，2号对文件B拥有访问权。
并且假定主机1号与2号之间的网络带宽很小。那么rsync算法将通过下面的五个步骤来完成：
1、2号将文件B分割成一组不重叠的固定大小为S字节的数据块，最后一块可能会比S 小。
2、2号对每一个分割好的数据块执行两种校验：一种是32位的滚动弱校验，另一种是128位的MD4强校验。
3、2号将这些校验结果发给1号。
4、1号通过搜索文件A的所有大小为S的数据块(偏移量可以任选，不一定非要是S的倍数)，
来寻找与文件B的某一块有着相同的弱校验码和强校验码的数据块。这项工作可以借助滚动校验的特性很快完成。
5、1号发给2号一串指令来生成文件A在2号上的备份。这里的每一条指令要么是对文件B经拥有某一个数据块而不须重传的证明，
要么是一个数据块，这个数据块肯定是没有与文件B的任何一个数据块匹配上的。
```

- Rsync参数说明
```
rsyncd.conf配置文件
－、全局参数
在文件中[module]之前的所有参数都是全局参数，当然也可以在全局参数部分定义模块参数，这时候该参数的值就是所有模块的默认值。
port
指定后台程序使用的端口号，默认为873。

motd file
"motd file"参数用来指定一个消息文件，当客户连接服务器时该文件的内容显示给客户，默认是没有motd文件的。


log file
"log file"指定rsync的日志文件，而不将日志发送给syslog。比如可指定为“/var/log/rsyncd.log”。


pid file
指定rsync的pid文件，通常指定为“/var/run/rsyncd.pid”。


syslog facility
指定rsync发送日志消息给syslog时的消息级别，常见的消息级别是：uth, authpriv, cron, daemon, ftp, kern, lpr, mail, news, security, sys-log, user, uucp, local0, local1, local2, local3,local4, local5, local6和local7。默认值是daemon。


二、模块参数
主要是定义服务器哪个目录要被同步。其格式必须为“[module]”形式，这个名字就是在rsync 客户端看到的名字，其实有点象Samba服务器提供的共享名。而服务器真正同步的数据是通过 path 来指定的。我们可以根据自己的需要，来指定多个模块，模块中可以定义以下参数：
comment
给模块指定一个描述，该描述连同模块名在客户连接得到模块列表时显示给客户。默认没有描述定义。


path
指定该模块的供备份的目录树路径，该参数是必须指定的。


use chroot
如果"use chroot"指定为true，那么rsync在传输文件以前首先chroot到path参数所指定的目录下。这样做的原因是实现额外的安全防护，但是缺点是需要以roots权限，并且不能备份指向外部的符号连接所指向的目录文件。默认情况下chroot值为true。


uid
该选项指定当该模块传输文件时守护进程应该具有的uid，配合gid选项使用可以确定哪些可以访问怎么样的文件权限，默认值是"nobody"。


gid
该选项指定当该模块传输文件时守护进程应该具有的gid。默认值为"nobody"。


max connections
指定该模块的最大并发连接数量以保护服务器，超过限制的连接请求将被告知随后再试。默认值是0，也就是没有限制。


list
该选项设定当客户请求可以使用的模块列表时，该模块是否应该被列出。如果设置该选项为false，可以创建隐藏的模块。默认值是true。


read only
该选项设定是否允许客户上载文件。如果为true那么任何上载请求都会失败，如果为false并且服务器目录读写权限允许那么上载是允许的。默认值为true。


exclude
用来指定多个由空格隔开的多个文件或目录(相对路径)，并将其添加到exclude列表中。这等同于在客户端命令中使用--exclude来指定模式，一个模块只能指定一个exclude选项。但是需要注意的一点是该选项有一定的安全性问题，客户很有可能绕过exclude列表，如果希望确保特定的文件不能被访问，那就最好结合uid/gid选项一起使用。


exclude from
指定一个包含exclude模式的定义的文件名，服务器从该文件中读取exclude列表定义。


include
用来指定不排除符合要求的文件或目录。这等同于在客户端命令中使用--include来指定模式，结合include和exclude可以定义复杂的exclude/include规则。


include from
指定一个包含include模式的定义的文件名，服务器从该文件中读取include列表定义。


auth users
该选项指定由空格或逗号分隔的用户名列表，只有这些用户才允许连接该模块。这里的用户和系统用户没有任何关系。如果"auth users"被设置，那么客户端发出对该模块的连接请求以后会被rsync请求challenged进行验证身份这里使用的challenge/response认证协议。用户的名和密码以明文方式存放在"secrets file"选项指定的文件中。默认情况下无需密码就可以连接模块(也就是匿名方式)。


secrets file
该选项指定一个包含定义用户名:密码对的文件。只有在"auth users"被定义时，该文件才有作用。文件每行包含一个username:passwd对。一般来说密码最好不要超过8个字符。没有默认的secures file名，需要限式指定一个(例如：/etc/rsyncd.passwd)。注意：该文件的权限一定要是600，否则客户端将不能连接服务器。


strict modes
该选项指定是否监测密码文件的权限，如果该选项值为true那么密码文件只能被rsync服务器运行身份的用户访问，其他任何用户不可以访问该文件。默认值为true。


hosts allow
该选项指定哪些IP的客户允许连接该模块。客户模式定义可以是以下形式：
单个IP地址，例如：192.167.0.1


整个网段，例如：192.168.0.0/24，也可以是192.168.0.0/255.255.255.0
多个IP或网段需要用空格隔开，“*”则表示所有，默认是允许所有主机连接。


hosts deny
指定不允许连接rsync服务器的机器，可以使用hosts allow的定义方式来进行定义。默认是没有hosts deny定义。


ignore errors
指定rsyncd在判断是否运行传输时的删除操作时忽略server上的IO错误，一般来说rsync在出现IO错误时将将跳过--delete操作，以防止因为暂时的资源不足或其它IO错误导致的严重问题。


ignore nonreadable
指定rysnc服务器完全忽略那些用户没有访问权限的文件。这对于在需要备份的目录中有些文件是不应该被备份者得到的情况是有意义的。


lock file
指定支持max connections参数的锁文件，默认值是/var/run/rsyncd.lock。


transfer logging
使rsync服务器使用ftp格式的文件来记录下载和上载操作在自己单独的日志中。


log format
通过该选项用户在使用transfer logging可以自己定制日志文件的字段。其格式是一个包含格式定义符的字符串，可以使用的格式定义符如下所示：
%h 远程主机名
%a 远程IP地址
%l 文件长度字符数
%p 该次rsync会话的进程id
%o 操作类型："send"或"recv"
%f 文件名
%P 模块路径
%m 模块名
%t 当前时间
%u 认证的用户名(匿名时是null)
%b 实际传输的字节数
%c 当发送文件时，该字段记录该文件的校验码
默认log格式为："%o %h [%a] %m (%u) %f %l"，一般来说,在每行的头上会添加"%t [%p] "。在源代码中同时发布有一个叫rsyncstats的perl脚本程序来统计这种格式的日志文件。


timeout
通过该选项可以覆盖客户指定的IP超时时间。通过该选项可以确保rsync服务器不会永远等待一个崩溃的客户端。超时单位为秒钟，0表示没有超时定义，这也是默认值。对于匿名rsync服务器来说，一个理想的数字是600。


refuse options
通过该选项可以定义一些不允许客户对该模块使用的命令参数列表。这里必须使用命令全名，而不能是简称。但发生拒绝某个命令的情况时服务器将报告错误信息然后退出。如果要防止使用压缩，应该是："dont compress = *"。


dont compress
用来指定那些不进行压缩处理再传输的文件，默认值是*.gz *.tgz *.zip *.z *.rpm *.deb *.iso *.bz2 *.tbz
```

- Rsync命令
```
在对rsync服务器配置结束以后，下一步就需要在客户端发出rsync命令来实现将服务器端的文件备份到客户端来。rsync是一个功能非常强大的工具，其命令也有很多功能特色选项，我们下面就对它的选项一一进行分析说明。
Rsync的命令格式可以为以下六种：
　　rsync [OPTION]... SRC DEST
　　rsync [OPTION]... SRC [USER@]HOST:DEST
　　rsync [OPTION]... [USER@]HOST:SRC DEST
　　rsync [OPTION]... [USER@]HOST::SRC DEST
　　rsync [OPTION]... SRC [USER@]HOST::DEST
　　rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]
　　对应于以上六种命令格式，rsync有六种不同的工作模式：
　　1)拷贝本地文件。当SRC和DES路径信息都不包含有单个冒号":"分隔符时就启动这种工作模式。如：rsync -a /data /backup
　　2)使用一个远程shell程序(如rsh、ssh)来实现将本地机器的内容拷贝到远程机器。当DST路径地址包含单个冒号":"分隔符时启动该模式。如：rsync -avz *.c foo:src
　　3)使用一个远程shell程序(如rsh、ssh)来实现将远程机器的内容拷贝到本地机器。当SRC地址路径包含单个冒号":"分隔符时启动该模式。如：rsync -avz foo:src/bar /data
　　4)从远程rsync服务器中拷贝文件到本地机。当SRC路径信息包含"::"分隔符时启动该模式。如：rsync -av root@172.16.78.192::www /databack
　　5)从本地机器拷贝文件到远程rsync服务器中。当DST路径信息包含"::"分隔符时启动该模式。如：rsync -av /databack root@172.16.78.192::www
　　6)列远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。如：rsync -v rsync://172.16.78.192/www
```

- rsync参数的具体解释
```

-v, --verbose 详细模式输出
-q, --quiet 精简输出模式
-c, --checksum 打开校验开关，强制对文件传输进行校验
-a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
-r, --recursive 对子目录以递归模式处理
-R, --relative 使用相对路径信息
-b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
--backup-dir 将备份文件(如~filename)存放在在目录下。
-suffix=SUFFIX 定义备份文件前缀
-u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
-l, --links 保留软链结
-L, --copy-links 想对待常规文件一样处理软链结
--copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结
--safe-links 忽略指向SRC路径目录树以外的链结
-H, --hard-links 保留硬链结
-p, --perms 保持文件权限
-o, --owner 保持文件属主信息
-g, --group 保持文件属组信息
-D, --devices 保持设备文件信息
-t, --times 保持文件时间信息
-S, --sparse 对稀疏文件进行特殊处理以节省DST的空间
-n, --dry-run现实哪些文件将被传输
-W, --whole-file 拷贝文件，不进行增量检测
-x, --one-file-system 不要跨越文件系统边界
-B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节
-e, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步
--rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息
-C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件
--existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件
--delete 删除那些DST中SRC没有的文件
--delete-excluded 同样删除接收端那些被该选项指定排除的文件
--delete-after 传输结束以后再删除
--ignore-errors 及时出现IO错误也进行删除
--max-delete=NUM 最多删除NUM个文件
--partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输
--force 强制删除目录，即使不为空
--numeric-ids 不将数字的用户和组ID匹配为用户名和组名
--timeout=TIME IP超时时间，单位为秒
-I, --ignore-times 不跳过那些有同样的时间和长度的文件
--size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间
--modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0
-T --temp-dir=DIR 在DIR中创建临时文件
--compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份
-P 等同于 --partial
--progress 显示备份过程
-z, --compress 对备份的文件在传输时进行压缩处理
--exclude=PATTERN 指定排除不需要传输的文件模式
--include=PATTERN 指定不排除而需要传输的文件模式
--exclude-from=FILE 排除FILE中指定模式的文件
--include-from=FILE 不排除FILE指定模式匹配的文件
--version 打印版本信息
--address 绑定到特定的地址
--config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件
--port=PORT 指定其他的rsync服务端口
--blocking-io 对远程shell使用阻塞IO
-stats 给出某些文件的传输状态
--progress 在传输时现实传输过程
--log-format=formAT 指定日志文件格式
--password-file=FILE 从FILE中得到密码
--bwlimit=KBPS 限制I/O带宽，KBytes per second
-h, --help 显示帮助信息
```


- Rsync使用实例
```
4.1、SSH方式
1、首先在服务端启动ssh服务：
# service sshd start
启动 sshd： [确定]

2、使用rsync进行同步
接下来就可以在客户端使用rsync命令来备份服务端上的数据了，SSH方式是通过系统用户来进行备份的，如下：
# rsync -vzrtopg --progress -e ssh --delete work@172.16.78.192:/www/* /databack/experiment/rsync
work@172.16.78.192's password:
receiving file list ...
5 files to consider
test/
a
0 100% 0.00kB/s 527:35:41 (1, 20.0% of 5)
b
67 100% 65.43kB/s 0:00:00 (2, 40.0% of 5)
c
0 100% 0.00kB/s 527:35:41 (3, 60.0% of 5)
dd
100663296 100% 42.22MB/s 0:00:02 (4, 80.0% of 5)

sent 96 bytes received 98190 bytes 11563.06 bytes/sec
total size is 100663363 speedup is 1024.19
上面的信息描述了整个的备份过程，以及总共备份数据的大小。

4.2 、后台服务方式

1、启动rsync服务
编辑/etc/xinetd.d/rsync文件，将其中的disable=yes改为disable=no，并重启xinetd服务，如下：
# vi /etc/xinetd.d/rsync
#default: off
# description: The rsync server is a good addition to an ftp server, as it \
# allows crc checksumming etc.
service rsync
{
disable = no
socket_type = stream
wait = no
user = root
server = /usr/bin/rsync
server_args = --daemon
log_on_failure += USERID
}

# /etc/init.d/xinetd restart
停止 xinetd： [确定]
启动 xinetd： [确定]

2、创建配置文件
默认安装好rsync程序后，并不会自动创建rsync的主配置文件，需要手工来创建，其主配置文件为“/etc/rsyncd.conf”，创建该文件并插入如下内容：
# vi /etc/rsyncd.conf
uid=root
gid=root
max connections=4
log file=/var/log/rsyncd.log
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
secrets file=/etc/rsyncd.passwd
hosts deny=172.16.78.0/22

[www]
comment= backup web
path=/www
read only = no
exclude=test
auth users=work


3、创建密码文件
采用这种方式不能使用系统用户对客户端进行认证，所以需要创建一个密码文件，其格式为“username:password”，用户名可以和密码可以随便定义，最好不要和系统帐户一致，同时要把创建的密码文件权限设置为600，这在前面的模块参数做了详细介绍。
# echo "work:abc123" > /etc/rsyncd.passwd
# chmod 600 /etc/rsyncd.passwd

4、备份
完成以上工作，现在就可以对数据进行备份了，如下：
# rsync -avz --progress --delete work@172.16.78.192::www /databack/experiment/rsync
Password:
receiving file list ...
6 files to consider
./ files...
a
0 100% 0.00kB/s 528:20:41 (1, 50.0% of 6)
b
67 100% 65.43kB/s 0:00:00 (2, 66.7% of 6)
c
0 100% 0.00kB/s 528:20:41 (3, 83.3% of 6)
dd
100663296 100% 37.49MB/s 0:00:02 (4, 100.0% of 6)

sent 172 bytes received 98276 bytes 17899.64 bytes/sec
total size is 150995011 speedup is 1533.75

5、恢复
当服务器的数据出现问题时，那么这时就需要通过客户端的数据对服务端进行恢复，但前提是服务端允许客户端有写入权限，否则也不能在客户端直接对服务端进行恢复，使用rsync对数据进行恢复的方法如下：
# rsync -avz --progress /databack/experiment/rsync/ work@172.16.78.192::www
Password:
building file list ...
6 files to consider
./
a
b
67 100% 0.00kB/s 0:00:00 (2, 66.7% of 6)
c

sent 258 bytes received 76 bytes 95.43 bytes/sec
total size is 150995011 speedup is 452080.87
```


- 示例脚本
```
这里这些脚本都是rsync网站上的例子：

1、每隔七天将数据往中心服务器做增量备份


#!/bin/sh


# This script does personal backups to a rsync backup server. You will end up
# with a 7 day rotating incremental backup. The incrementals will go
# into subdirectories named after the day of the week, and the current
# full backup goes into a directory called "current"
# tridge@linuxcare.com


# directory to backup
BDIR=/home/$USER


# excludes file - this contains a wildcard pattern per line of files to exclude
EXCLUDES=$HOME/cron/excludes


# the name of the backup machine
BSERVER=owl


# your password on the backup server
export RSYNC_PASSWORD=XXXXXX




########################################################################


BACKUPDIR=`date +%A`
OPTS="--force --ignore-errors --delete-excluded --exclude-from=$EXCLUDES
--delete --backup --backup-dir=/$BACKUPDIR -a"


export PATH=$PATH:/bin:/usr/bin:/usr/local/bin


# the following line clears the last weeks incremental directory
[ -d $HOME/emptydir ] || mkdir $HOME/emptydir
rsync --delete -a $HOME/emptydir/ $BSERVER::$USER/$BACKUPDIR/
rmdir $HOME/emptydir


# now the actual transfer
rsync $OPTS $BDIR $BSERVER::$USER/current


2、备份至一个空闲的硬盘


#!/bin/sh


export PATH=/usr/local/bin:/usr/bin:/bin


LIST="rootfs usr data data2"


for d in $LIST; do
mount /backup/$d
rsync -ax --exclude fstab --delete /$d/ /backup/$d/
umount /backup/$d
done


DAY=`date "+%A"`


rsync -a --delete /usr/local/apache /data2/backups/$DAY
rsync -a --delete /data/solid /data2/backups/$DAY


3、对vger.rutgers.edu的cvs树进行镜像


#!/bin/bash


cd /var/www/cvs/vger/
PATH=/usr/local/bin:/usr/freeware/bin:/usr/bin:/bin


RUN=`lps x | grep rsync | grep -v grep | wc -l`
if [ "$RUN" -gt 0 ]; then
echo already running
exit 1
fi


rsync -az vger.rutgers.edu::cvs/CVSROOT/ChangeLog $HOME/ChangeLog


sum1=`sum $HOME/ChangeLog`
sum2=`sum /var/www/cvs/vger/CVSROOT/ChangeLog`


if [ "$sum1" = "$sum2" ]; then
echo nothing to do
exit 0
fi


rsync -az --delete --force vger.rutgers.edu::cvs/ /var/www/cvs/vger/
exit 0
```

- FAQ
```
Q：如何通过ssh进行rsync，而且无须输入密码？
A：可以通过以下几个步骤


1. 通过ssh-keygen在server A上建立SSH keys，不要指定密码，你会在~/.ssh下看到identity和identity.pub文件
2. 在server B上的home目录建立子目录.ssh
3. 将A的identity.pub拷贝到server B上
4. 将identity.pub加到~[user b]/.ssh/authorized_keys
5. 于是server A上的A用户，可通过下面命令以用户B ssh到server B上了
e.g. ssh -l userB serverB
这样就使server A上的用户A就可以ssh以用户B的身份无需密码登陆到server B上了。


Q：如何通过在不危害安全的情况下通过防火墙使用rsync?
A：解答如下：


这通常有两种情况，一种是服务器在防火墙内，一种是服务器在防火墙外。无论哪种情况，通常还是使用ssh，这时最好新建一个备份用户，并且配置sshd仅允许这个用户通过RSA认证方式进入。如果服务器在防火墙内，则最好限定客户端的IP地址，拒绝其它所有连接。如果客户机在防火墙内，则可以简单允许防火墙打开TCP端口22的ssh外发连接就ok了。


Q：我能将更改过或者删除的文件也备份上来吗？
A：当然可以：


你可以使用如：rsync -other -options -backupdir = ./backup-2000-2-13 ...这样的命令来实现。
这样如果源文件:/path/to/some/file.c改变了，那么旧的文件就会被移到./backup-2000-2-13/path/to/some/file.c，
这里这个目录需要自己手工建立起来


Q：我需要在防火墙上开放哪些端口以适应rsync？
A：视情况而定


rsync可以直接通过873端口的tcp连接传文件，也可以通过22端口的ssh来进行文件传递，但你也可以通过下列命令改变它的端口：


rsync --port 8730 otherhost::
或者
rsync -e 'ssh -p 2002' otherhost:


Q：我如何通过rsync只复制目录结构，忽略掉文件呢？
A：rsync -av --include '*/' --exclude '*' source-dir dest-dir


Q：为什么我总会出现"Read-only file system"的错误呢？
A：看看是否忘了设"read only = no"了


Q：为什么我会出现'@ERROR: invalid gid'的错误呢？
A：rsync使用时默认是用uid=nobody;gid=nobody来运行的，如果你的系统不存在nobody组的话，就会出现这样的错误，可以试试gid = nogroup或者其它


Q：绑定端口873失败是怎么回事？
A：如果你不是以root权限运行这一守护进程的话，因为1024端口以下是特权端口，会出现这样的错误。你可以用--port参数来改变。


Q：为什么我认证失败？
A：从你的命令行看来：


你用的是：
> bash$ rsync -a 144.16.251.213::test test
> Password:
> @ERROR: auth failed on module test
>
> I dont understand this. Can somebody explain as to how to acomplish this.
> All suggestions are welcome.


应该是没有以你的用户名登陆导致的问题，试试rsync -a max@144.16.251.213::test test
```
