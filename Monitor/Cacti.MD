# Cacti
```
Cacti是一套基于PHP、MySQL、SNMP及RRDTool开发的网络流量监测图形分析工具.
```

# Cacti的工作流程
```
步骤一，snmp协议收集远程服务器的数据
步骤二，将snmp收集的数据内容保存到rrd数据库中
步骤三，若用户查看某台设备上的流量或其它状态信息
步骤四，在mysql数据库中查找该设备对应的rra数据库文件的名称
步骤五，通过rrdtool命令进行绘图即可
```


* 部署
```
Yum源
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
时间同步
ntpdate 202.120.2.101
LAMP环境
yum install -y httpd php php-mysql php-snmp php-xml php-gd mysql mysql-server gd gd-devel
service httpd start
service mysqld start
yum install -y net-snmp net-snmp-utils
vim /etc/snmp/snmpd.conf
修改前，
view systemview included .1.3.6.1.2.1.1
修改后，
view systemview included .1.3.6.1.2.1
service snmpd start
安装RRDTool
yum install -y rrdtool

安装Cacti
wget http://www.cacti.net/downloads/cacti-0.8.8b.tar.gz
[root@node1 ~]# mkdir -pv /web/vhosts/cacti
[root@node1 ~]# tar xf cacti-0.8.8b.tar.gz
[root@node1 ~]# cd cacti-0.8.8b
[root@node1 cacti-0.8.8b]# mv * /web/vhosts/cacti/
[root@node1 cacti-0.8.8b]# cd /web/vhosts/cacti/
其中cacti.sql是保存了cacti到所有表的语句

MYSQL初始化
mysqladmin create cactidb
mysql cactidb < cacti.sql

[root@node1 cacti]# mysql -e "GRANT ALL ON cactidb.* TO cactiuser@localhost IDENTIFIED BY 'cactiuser'"
[root@node1 cacti]# mysqladmin flush-privileges
[root@node1 cacti]# mysql -ucactiuser -pcactiuser
```
* Cacti配置虚拟主机
```
Cacti就是个PHP程序是基于LAMP环境运行
vim /etc/httpd/conf/httpd.conf
<VirtualHost *:80>
  DocumentRoot /web/vhosts/cacti
  ServerName cacti.test.com
  ErrorLog logs/cacti.test.com-error_log
  CustomLog logs/cacti.test.com-access_log common
  <Directory "/web/vhosts/cacti">
    Options Indexes FollowSymLinks
    DirectoryIndex index.php index.html index.htm
    AllowOverride None
    Order allow,deny
    Allow from all
  </Directory>
</VirtualHost>

cacti程序的配置文件
[root@node1 ~]# cd /web/vhosts/cacti/
[root@node1 cacti]# cd include/
[root@node1 include]# vim config.php

/* make sure these values refect your actual database/host/user/password */
$database_type = "mysql";
$database_default = "cactidb";
$database_hostname = "localhost";
$database_username = "cactiuser";
$database_password = "cactiuser";
$database_port = "3306";
$database_ssl = false;
$url_path ="/"; #这一行非常重要设置cacti程序访问路径的

cacti用户
[root@node1 ~]# cd /web/vhosts/cacti/
[root@node1 cacti]# useradd cactiuser
[root@node1 cacti]# chown -R cactiuser:cactiuser log/ rra/
```

* 测试
```
php页面并测试php环境
[root@node1 ~]# cd /var/www/html/
[root@node1 html]# vim index.php

<?php

    phpinfo();

?>

重新启动一下httpd并初始化cacti
hosts文件配置
http://cacti.test.com/install
```

