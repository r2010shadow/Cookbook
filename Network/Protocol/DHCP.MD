# Dynamic Host Configuration Protocol

- 服务器使用**UDP端口67**
- 客户端使用**UDP端口68**
- **ipconfig /renew** 
- - 手动发起获取IP过程
- ipconfig /release 
- - 释放获取到的IP

## 网络接口的配置  

* vim /etc/sysconfig/dhcpd
```
#指定网络接口名称，在eth0 网络接口上启用dhcp 服务。
DHCPDARGS=eth0
创建DHCP服务器租约文件
touch /var/db/dhcpd.leases
vi /etc/rc.d/init.d/dhcpd 
user=dhcpd 
group=dhcpd 
改为 
user=root 
group=root
```

* vi /etc/dhcp/dhcpd.conf
```
ddns-update-style interim;   
#表示dhcp服务器和dns服务器的动态信息更新模式  
ignore client-updates;     
#忽略客户端更新  
subnet 192.168.145.0 netmask 255.255.255.0 {     
range 192.168.145.200 192.168.145.210; 
#租用IP地址的范围 
option domain-name-servers ns.example.org; 
option domain-name "example.org"; 
option routers 192.168.145.101;
#路由器地址，这里是当前 dhcp 机器的IP地址 
option subnet-mask 255.255.255.0;         
#子网掩码 
default-lease-time 600;              
#默认租约时间 
max-lease-time 7200;                
#最大租约时间 
host myhost {                   
#设置主机声明 
hardware ethernet 08:00:27:2C:30:8C;       
#指定dhcp客户的mac地址  
fixed-address 192.168.145.155;          
#给指定的mac地址分配ip 
```
* 启动服务命令两种方法：
```
/etc/init.d/dhcpd start
service dhcpd start
查看启动是否成功：
# netstat -panu | grep dhc*
客户租约的数据库文件dhcpd.leases# 
cat /var/lib/dhcpd/dhcpd.leases
```

