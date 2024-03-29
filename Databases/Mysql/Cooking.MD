## Linux Mysql
* Pre Install
```
yum -y install make gcc-c++ cmake bison-devel  ncurses-devel
```

* Install source code
```
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.17.tar.gz

tar xvf mysql-5.6.17.tar.gz
cd mysql-5.6.17

cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci

make && make install
```

* Deploy
```
groupadd mysql
useradd -g mysql mysql
chown -R mysql:mysql /usr/local/mysql

cd /usr/local/mysql
scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql

cp support-files/mysql.server /etc/init.d/mysql
chkconfig mysql on
service mysql start
```
* Deploy user
```
PATH=/usr/local/mysql/bin:$PATH
export PATH
source /etc/profile

mysql -uroot  
mysql> SET PASSWORD = PASSWORD('PASSWORD');

mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.16.%' IDENTIFIED BY 'password' WITH GRANT OPTION;
```


* Firewall
```
vi /etc/sysconfig/iptables
-A INPUT m state --state NEW m tcp p dport 3306 j ACCEPT
service iptables restart
```




* 参数
```
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \ #安装路径
 
-DMYSQL_DATADIR=/usr/local/mysql/data \ #数据文件存放位置
 
-DSYSCONFDIR=/etc \ #my.cnf路径
 
-DWITH_MYISAM_STORAGE_ENGINE=1 \ #支持MyIASM引擎
 
-DWITH_INNOBASE_STORAGE_ENGINE=1 \ #支持InnoDB引擎
 
-DWITH_MEMORY_STORAGE_ENGINE=1 \ #支持Memory引擎
 
-DWITH_READLINE=1 \ #快捷键功能(我没用过)
 
-DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \ #连接数据库socket路径
 
-DMYSQL_TCP_PORT=3306 \ #端口
 
-DENABLED_LOCAL_INFILE=1 \ #允许从本地导入数据
 
-DWITH_PARTITION_STORAGE_ENGINE=1 \ #安装支持数据库分区
 
-DEXTRA_CHARSETS=all \ #安装所有的字符集
 
-DDEFAULT_CHARSET=utf8 \ #默认字符
 
-DDEFAULT_COLLATION=utf8_general_ci #默认校对规则
 
utf8_general_ci 不区分大小写
 
utf8_general_cs 区分大小写
```



* DDL  pt-online-schema-change
```
https://www.percona.com/doc/percona-toolkit/2.1/pt-online-schema-change.html

yum install perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker perl-Digest-MD5 -y
perl Makefile.PL
make && make install

create database test;
CREATE TABLE `pt` (
 `id` int(11) NOT NULL DEFAULT '0',
 `disktype` enum('sas','shannon','memdisk') NOT NULL,
 `blocksize` enum('4K','64K','256K','1M') NOT NULL,
 `testmode` enum('seqwr','seqrewr','seqrd','rndrd','rndwr','rndrw') NOT NULL,
 `thread` enum('1','2','4','8','16','32') NOT NULL,
 `bandwidth` float(10,2) unsigned NOT NULL,
 `resptime` float(10,2) unsigned NOT NULL DEFAULT '0.00',
 PRIMARY KEY (`id`),
 UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
#修改字段
pt-online-schema-change --user=root --password=welcome --alter "CHANGE resptime responsetime float(10,2) unsigned not NULL default '0'" D=mytest,t='pt' --execute --print --statistics --no-check-alter

#增加列
pt-online-schema-change --user=root --password=welcome --alter "add p1 float(10,2) not NULL default '0'" D=test,t='pt' --execute --print --statistics --no-check-alter

#删除列
pt-online-schema-change --user=root --password=welcome --alter "drop p1" D=mytest,t='pt' --execute --print --statistics --no-check-alter
```

* monitor
```
# per sec operate
show global status where Variable_name in('com_select','com_insert','com_delete','com_update');

# qps 每秒处理的查询数
  tps 每秒处理的事务数
  IOPS，每秒磁盘进行的I/O操作次数

QPS (Query per second) （每秒查询量）
TPS(Transaction per second) （每秒事务量，如果是InnoDB会显示，没有InnoDB就不会显示）

QPS
Questions = SHOW GLOBAL STATUS LIKE 'Questions';
Uptime = SHOW GLOBAL STATUS LIKE 'Uptime';
QPS=Questions/Uptime
TPS
Com_commit = SHOW GLOBAL STATUS LIKE 'Com_commit';
Com_rollback = SHOW GLOBAL STATUS LIKE 'Com_rollback';
Uptime = SHOW GLOBAL STATUS LIKE 'Uptime';
TPS=(Com_commit + Com_rollback)/Uptime

```


* check
```
show engine innodb status\G;

```


##  windows zip mode

* get
```
https://dev.mysql.com/downloads/mysql/
```

* set
```
mkdir d:\mysql\data 
设置环境变量，鼠标选中“计算机” >>然后点击鼠标右键，选择属性>>“高级系统设置”>>“环境变量”
新建一个环境变量MYSQL_HOME，他的值为D:\mysql
还要在PATH路径上添加Mysql的bin目录，也就是D:\mysql\bin

 d:/mysql/my.ini
[mysqld]

#设置3306端口
port=3306

#设置mysql的安装目录
basedir=D:\\mysql

# 切记此处一定要用双斜杠\\，单斜杠我这里会出错。
#设置mysql数据库的数据的存放目录
datadir=D:\\mysql\\data  

# 此处同上#允许最大连接数
max_connections=200

#允许连接失败的次数。这是为了防止有人从该主机试图攻击数据库系统
max_connect_errors=10

#服务端使用的字符集默认为UTF8
character-set-server=utf8

#创建新表时将使用的默认存储引擎
default-storage-engine=INNODB

#默认使用“mysql_native_password”插件认证
default_authentication_plugin=mysql_native_password

[mysql]
#设置mysql客户端默认字符集
default-character-set=utf8

[client]
#设置mysql客户端连接服务端时默认使用的端口
port=3306
default-character-set=utf8
```
* run 
```
cd d:/mysql/bin

# 获取临时密码
mysqld --initialize --console

# 服务部署
mysqld --install 

net start mysql

# 修改临时密码
mysql -uroot -p
ALTER USER 'root'@'localhost' IDENTIFIED BY $pwd;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY $pwd;  # navcat connect
update user set host = '%' where user = 'root';         # for remote client connect
flush privileges;
```
* test
```
mysqlshow -uroot -p$pwd
```

* more
```
case:找不到msvcp140.dll
安装Microsoft Visual C++ 2015 Redistributable
https://www.microsoft.com/en-us/download/details.aspx?id=53587
```

## Mariadb

* get 
```
yum -y install mariadb mariadb-devel mariadb-server
```

* run
```
systemctl enable mariadb
systemctl start mariadb

mysql_secure_installation     # 初始化密码
```




## master and slave

### master
``` 
 /etc/my.cnf.d/server.cnf 
[mysqld]
server_id=1                 #设置当前服务器的ID号
log_bin=log-bin             #启动二进制日志并指定文件名
skip_name_resolve=on        #跳过主机名解析。在CentOS 6自带的mysql后面的=on不用写
innodb_file_per_table=on    #innodb的每个表是用单独的文件 
 
 
 
 
```
* grant
```
grant replication slave,replication client on *.* to 'repluser'@'10.10.%.%' identified by 'repluser';
```
* check
```
 show variables like 'log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+
```

* lock table  关闭所有打开的表
```
 FLUSH TABLES WITH READ LOCK;
 show processlist\G;     # 查看未关闭表
 |  6 | root | localhost | test | Field List |   35 | Waiting for table |    # 也许是select *此类操作未结束
 
 MariaDB [server]> create table mytbl3 like users_user;   # 尝试创建新表及报错信息
 ERROR 1223 (HY000): Can't execute the query because you have a conflicting read lock 
``` 
* mysqldump  导出需要同步到slave的库 %.sql
```
 mysqldump -uroot -p%pwd somedb > somedb.sql

 show master status;
+----------------+----------+--------------+------------------+
| File           | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+----------------+----------+--------------+------------------+
| log-bin.000001 |      493 |              |                  |
+----------------+----------+--------------+------------------+ 
 show binlog events in 'log-bin.000001';
```

* 解锁    导出库后一定要解锁
```
 unlock tables;
```


### slave
```
 /etc/my.cnf.d/server.cnf 
[mysqld]
server_id=2
relay_log=relay-log         #启用中继日志。在数据目录下有一个relay-kog.info里面保存了当前的中继日志和位置会主节点二进制文件的名字和位置。
read_only=on                #禁止用户写入数据，这一项的管理员和复制重放无效。

#set slave
change master to master_host='10.10.9.119', master_user='repluser',master_password='%pwd',master_log_file='log-bin.000001',master_log_pos=493;
show slave status\G;


# test master and check slave mytbl exist or not
create table mytbl like sometable;


# reset slave
会清除从库的所有复制信息。
一般应用场景：如切换为不同的Master, 主从重做等；
1. 命令在slave上执行，执行前一定要stop slave。
2. 执行reset slave后，会清除复制相关的所有信息，包括：master.info, relay-log.info， 及无条件删除所有的中继日志（relay logs). 
   注意是无条件的，也就是不管理你Slave SQL线程是否把所有的relay log重放完了。
3. 注意，stop slave后，先保存show slave status信息，然后再执行reset slave. 一般这个信息都会有用的。

# Slave Error log:Could not find first log file name in binar y log index file
## fix
1. master root:(none)> flush logs;     # 在master 关闭当前使用的binary log，然后打开一个新的binary log文件，文件的序号加1
2. show master status;
3. stop slave
4. change master to master_host='10.10.2.12',master_user='root',master_password='PWD',master_log_file='db01-012.000002',master_log_pos=3603963; 
5. start slave
6. show slave status\G;
```


* Aborted
```
TYPE:
[Warning] Aborted connection 305628 to db: 'db' user: 'dbuser' host: 'hostname' (Got an error reading communication packets)


show global variables like '%timeout%';
+-----------------------------+----------+
| Variable_name               | Value    |
+-----------------------------+----------+
| connect_timeout             | 10       |
| delayed_insert_timeout      | 300      |
| have_statement_timeout      | YES      |
| innodb_flush_log_at_timeout | 1        |
| innodb_lock_wait_timeout    | 50       |
| innodb_rollback_on_timeout  | OFF      |
| interactive_timeout         | 28800    |  #
| lock_wait_timeout           | 31536000 |
| net_read_timeout            | 30       |
| net_write_timeout           | 60       |
| rpl_stop_slave_timeout      | 31536000 |
| slave_net_timeout           | 60       |
| wait_timeout                | 28800    |  #
+-----------------------------+----------+

# 2个参数同时调整
set global wait_timeout=31536000;
set global interactive_timeout=31536000；

show global status like 'aborted%';
观察什么情况下会增加

show global variables like 'max_conn%';
查看最大连接数
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| max_connect_errors | 500   |
| max_connections    | 500   |
+--------------------+-------+

set global max_connect_errors=2000；
set global max_connections=2000;

```

* mysqldump 
```
## Case: dont lock table
1. dump
mysqldump  --skip-lock-tables --single-transaction --flush-logs --hex-blob --master-data=2 --databases DatabaseName -hHOSTIP -uroot -p  -PPORT > DatabaseName.sql 
2. check pos
head DatabaseName.sql -n 80 | grep 'MASTER_LOG_POS'
```
