Netcat

#TestPort
nc -nvv -w 2 IP 8899


# CS Connect 
> hostA
nc -lk 9999

> hostB
telnet IP 9999



1、远程拷贝文件 从server1拷贝文件到server2上。需要先在server2上，用nc激活监听，server2上运行：

引用[root@hatest2 tmp]# nc -lp 1234 > install.log

server1上运行：

引用[root@hatest1 ~]# ll install.log -rw-r--r--   1 root root 39693 12月 20   2007 install.log [root@hatest1 ~]# nc -w 1 192.168.228.222 1234 < install.log

2、克隆硬盘或分区 操作与上面的拷贝是雷同的，只需要由dd获得硬盘或分区的数据，然后传输即可。 克隆硬盘或分区的操作，不应在已经mount的的系统上进行。所以，需要使用安装光盘引导后，进入拯救模式（或使用Knoppix工具光盘）启动系统后，在server2上进行类似的监听动作：

# nc -l -p 1234 | dd of=/dev/sda

server1上执行传输，即可完成从server1克隆sda硬盘到server2的任务：

# dd if=/dev/sda | nc 192.168.228.222 1234

※ 完成上述工作的前提，是需要落实光盘的拯救模式支持服务器上的网卡，并正确配置IP。
3、端口扫描 可以执行：

引用# nc -v -w 1 192.168.228.222 -z 1-1000 hatest2 [192.168.228.222] 22 (ssh) open

4、保存Web页面

# while true; do nc -l -p 80 -q 1 < somepage.html; done

5、模拟HTTP Headers

引用[root@hatest1 ~]# nc www.linuxfly.org 80 GET / HTTP/1.1 Host: ispconfig.org Referrer: mypage.com User-Agent: my-browser
HTTP/1.1 200 OK Date: Tue, 16 Dec 2008 07:23:24 GMT Server: Apache/2.2.6 (Unix) DAV/2 mod_mono/1.2.1 mod_python/3.2.8 Python/2.4.3 mod_perl/2.0.2 Perl/v5.8.8 Set-Cookie: PHPSESSID=bbadorbvie1gn037iih6lrdg50; path=/ Expires: 0 Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0 Pragma: no-cache Cache-Control: private, post-check=0, pre-check=0, max-age=0 Set-Cookie: oWn_sid=xRutAY; expires=Tue, 23-Dec-2008 07:23:24 GMT; path=/ Vary: Accept-Encoding Transfer-Encoding: chunked Content-Type: text/html [......]

在nc命令后，输入红色部分的内容，然后按两次回车，即可从对方获得HTTP Headers内容。
6、聊天 nc还可以作为简单的字符下聊天工具使用，同样的，server2上需要启动监听：

[root@hatest2 tmp]# nc -lp 1234

server1上传输：

[root@hatest1 ~]# nc 192.168.228.222 1234

这样，双方就可以相互交流了。使用Ctrl+D正常退出。
7、传输目录 从server1拷贝nginx-0.6.34目录内容到server2上。需要先在server2上，用nc激活监听，server2上运行：

引用[root@hatest2 tmp]# nc -l 1234 |tar xzvf -

server1上运行：

引用[root@hatest1 ~]# ll -d nginx-0.6.34 drwxr-xr-x 8 1000 1000 4096 12-23 17:25 nginx-0.6.34 [root@hatest1 ~]# tar czvf - nginx-0.6.34|nc 192.168.228.222 1234


