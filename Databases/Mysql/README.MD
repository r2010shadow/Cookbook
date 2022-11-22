# Cooking Mysql
```
MySQL数据库的历史可以追溯到1979年，那时Bill Gates退学没多久，微软公司也才刚刚起步，而Larry Ellison的Oracle公司 也才成立不久。那个时候有一个天才程序员Monty Widenius为一个名为TcX的小公司打工，并且用BASIC设计了一个报表工具，使其 可以在4MHz主频和16KB内存的计算机上运行。没过多久，Monty又将此工具用C语言进行了重新编写并移植到了UNIX平台上。当时， 这只是一个很底层且仅面向报表的存储引擎，名叫UNIREG。最初的UNIREG是运行在瑞典人制造的ABC800计算机上的。ABC800的内存 只有32KB，CPU是频率只有4MHz的Z80。在1983年Monty Widenius遇到了David Axmark，两人相见恨晚，开始合作运营TcX，Monty Widenius负责技术，David Axmark负责搞管理。后来TcX将UNIREG移植到其他更加强大的硬件平台，主要是Sun的平台。虽然TcX这个 小公司资源有限，但Monty Widenius天赋极高，面对资源有限的不利条件，反而更能发挥他的潜能。Monty Widenius总是力图写出 最高效的代码，并因此养成了习惯。与Monty Widenius在一起的还有一些别的同事，很少有人能坚持把那些代码持续写到20年后， 而Monty Widenius却做到了。

1990年，一次Monty接到了一个项目，客户需要为当时的UNIREG提供更加通用的SQL接口，当时有人提议直接使用商用数据库， 但是Monty Widenius觉得商用数据库的速度难以令人满意。于是Monty Widenius找到了David Hughes(mSQL的发明人)商讨合作事宜 。想借助于mSQL的代码，将它集成到自己的存储引擎中。然而令人失望的是，在经过一番测试后，他们发现mSQL的速度并不尽如人 意，无法满足客户的需求。于是Monty Widenius雄心大起，决心自己重写一个SQL支持。从此MySQL就开始诞生了。
```



* 常用

| select version();                                        | 服务重启后失效                                     |
| -------------------------------------------------------- | -------------------------------------------------- |
| SHOW VARIABLES LIKE 'character_set%';                    |                                                    |
| SHOW VARIABLES LIKE 'collation%';                        |                                                    |
| SHOW VARIABLES LIKE '%max_allowed_packet';               |                                                    |
| set global max_allowed_packet=104857600;                 | 重新登录客户端观察                                 |
| SHOW VARIABLES LIKE 'innodb_strict_mode';                | InnoDB严格检查模式                                 |
| set global innodb_strict_mode=0;                         | 开启                                               |
| set global COLLATION_SERVER=utf8mb4_general_ci;          |                                                    |
| SHOW VARIABLES LIKE 'log_bin_trust_function_creators';   |                                                    |
| set global log_bin_trust_function_creators=1;            | 用于主从复制，而存储函数有可能导致主从的数据不一致 |
| SET PASSWORD FOR 'dbadmin'@'localhost' = 'newpasswd2';   |                                                    |
| ALTER USER dbadmin@localhost IDENTIFIED BY 'newpasswd3'; |                                                    |
|                                                          |                                                    |

---
- MySQL连接层：
连接层为每个连接维护一个线程。该线程处理查询执行。 在连接可以开始发送 SQL 查询之前，连接由验证用户名、密码和客户端主机。 连接层通过多种连接协议接受来自应用程序的连接：
```
TCP/IP
UNIX 套接字
共享内存
命名管道
```

- 连接协议：
协议在客户端库和驱动程序中实现。
连接协议的速度因本地设置而异。
除了旧版 MySQL 经典协议之外，MySQL X 协议还引入了MySQL 5.7.12 并在 MySQL 8.0 中默认启用。
MySQL 使用 TCP 将消息从客户端通过网络传输到服务器，可以使用以 mysqlx 为前缀的变量和选项来配置 MySQL X 协议。
```
本地和远程连接协议：TCP/IP
TCP/IP（传输控制协议/互联网协议）：
1、是用于连接 Internet 上的主机的连接协议套件
2、使用 IP 地址或 DNS 主机名来识别主机
3、使用 TCP 端口号来标识每个主机上的特定服务
MySQL 默认 TCP 端口号：
1、3306 用于 MySQL Classic 协议（服务器端口选项）
2、33060 用于 MySQL X 协议（服务器 mysqlx_port 选项）
3、33062 用于使用 MySQL Classic 协议的管理连接（服务器 admin_port 选项）
```

- data 数据目录更换
```
vim /etc/my.cnf

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

ln -s /mnt/data/mysql/mysql.sock /var/lib/mysql/mysql.sock
systemctl start mysqld.service
```
