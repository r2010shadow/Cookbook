# Cisco route
## Command
```
Route>     //用户模式

enable  //进入特权模式

config terminal  //进去全局配置模式

hostname route1  //设置路由器的名称为route1
C
enable secret  cisco  //设置enable加密口令为cisco（以密文显示，权限高）

enable password  cisco //设置enable口令（以明文显示，两者同时配置，前者生效）
line console 0  //进入控制台线路配置模式(超级终端)
password  cisco    //设置console登录密码为cisco
exec-timeout 30 30  //设置路由器超时时间为30分钟，30秒后自动弹出到用户模式，
                      设置为0 0 则永远不超时。
Login            //要求登录时输入口令
line vty 0 4  //进入虚拟终端线路配置模式（telnet）

exec-timeout 30 30  //设置路由器超时时间为30分钟，30秒后自动弹出到用户模式，
                      设置为0 0 则永远不超时。后一个30的单位是秒。
password  cisco    //设置VTY登录密码为cisco

exit   //退出当前模式

copy running-config startup-config  //将更改保存到nvram
service password-encryption  //对所有密码加密

interface fa0/0   //进入fa0/0接口配置模式

ip address 192.168.1.1 255.255.255.0  //设置接口IP地址

no shutdown   //激活接口

interface s0   //进入s0接口

ip address 192.168.2.2 255.255.255.0

clock rate 9600   //设置时钟频率

no shutdown

exit

ip routing  //允许路由配置。没有该语句将导致配置的路由无效。

No ip routing  //关掉路由功能，就可以模拟交换机

ip route 目标网段 子网掩码 下一跳入口IP地址  //静态路由

ip route 0.0.0.0 0.0.0.0 下一跳入口IP地址  //默认路由
            //仅当R不知道如何转发分组时，它才会使用默认
exit
end  //退出到特权模式（与ctrl+z一样）
保存
copy run sta
wr

备份
copy startup-config tftp   //备份至tftp

恢复
copy tftp startup-config
```
## show cmd
```
show interface fa0/0   //查看fa0/0接口信息
show ip protocol  //查看路由协议
show ip interface brief  //查看端口简要信息
show ip route  //查看路由表- C直接路由、动态更新、默认路由、静态路由

```
## IPV6 CONFIG
```
Config terminal

Hostname R1

Ipv6 unicast-routing   //开启ipv6单播路由

Interface f0/0
Ipv6 add 2005:CCCC::1/64  
ipv6 route 2005:CCCC::1/64 f0/0  //静态路由
No shutdown

Exit

Interface serial0/2/0
Ipv6 add 2007:CCCC::1/64
Clock rate 128000

Exit

Ipv6 route 2004:CCCC::/64 serial0/2/0
```
## DHCP
```
ena 
conf t
int fa 0/0
ip add 192.168.1.1 255.255.255.0
nu shut
exit
ip dhcp pool DHCPserver        
network 192.168.1.1 255.255.255.0           //指定子网
ip dhcp excluded-address IP IP   //排查IP
domain-name cisco.com            //指定域名
dns server IP IP
default-router 192.168.1.1       //设默认网关
lease {days [hours] [minutes] infinite}      //设租用时间
end

```
## 访问控制列表ACL
```
（1）允许网络地址172.16.0.0通过，但拒绝172.16.19.2通过
Config terminal

Access-list 1 deny host 172.16.19.2

Access-list 1 permit 172.16.0.0 0.0.255.255

Interface fa0/1

Ip access-group 1 out

(2)禁止主机A（172.16.16.2）远程登录路由器B（172.16.17.1）

Access-list number permit|deny protocol source destination

Config terminal

Access-list 110 deny tcp host 172.16.16.2 host 172.16.17.1 eq telnet

Access-list 110 permit ip any any

Interface fa0/1                    

Ip access-group 110 out

(3)允许主机A（172.16.16.2）远程登录路由器B（172.16.17.1）

Config terminal

Access-list 110 permit tcp host 172.16.16.2 host 172.16.17.1 eq telnet

Interface fa0/1                    

Ip access-group 110 out
```
