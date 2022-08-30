# Cisco Switch
## 指示灯

| 交换机指示灯   | 描述                                                         |
| -------------- | ------------------------------------------------------------ |
| 系统指示灯     | 灭：系统未通电 绿色：系统已加电且运行正常 淡黄色：系统出现故障，发生了一个或多个POST错误 |
| 冗余电源指示灯 | 灭：没有冗余电源或冗余电源被关闭 绿色：冗余电源正常 绿色闪烁：连接了冗余电源，但不可用，因为它正在为其他设备供电 淡黄色：有冗余电源，但不正常 淡黄色闪烁：内部电源出现了故障，交换机由冗余电源供电 |

| 端口指示灯显示模式           | 描述                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| 端口状态 （STAT指示灯亮）    | 灭：没有连接链路 绿色：连接了链路，但没有活动 绿色闪烁：链路上有数据流传输 交替显示绿色和淡黄色：链路出现了故障。 错误帧可能影响连接性。冲突过多、 循环冗余校验（CRC）错误、帧长错误和超 时错误都会导致链路故障 淡黄色：端口没转发数据（由于端口被管理性关闭）、 被挂起（由于地址非法）或为避免网络环路而被生成树协议（STP）挂起 |
| 带宽使用情况 （UTL指示灯亮） | 绿色：以对数值指示当前占用的带宽 淡黄色：交换机通电后最大的带宽使用量 交替显示绿色和淡黄色：取决于交换机型号，具体情况如下： 对于Catalyst 2960-12、2960-24、2960C-24和2960T-24交换机，如果所有端口指示灯都为绿色，则使用的带宽不低于总带宽的50%；如果最右边的指示灯灭，则带宽使用率为25%~50%；依此类推，如果只有最左边的指示灯呈绿色，则带宽使用率低于0.0488% 对于Catalyst 2960G-12-EI交换机，如果所有端口指示灯都呈绿色，则带宽使用率不低于50%；如果第二个GBIC（吉比特接口转换器）模块插槽的指示灯不亮，则带宽使用率为25%~50%；如果两个GBIC模块插槽的指示灯都不亮，则带宽使用率低于25%；依次类推 对于Catalyst 2960G-24-EI和2960G-24-EI-DC交换机，如果所有端口指示灯都呈绿色，则带宽使用率不低于50%；如果第二个GBIC模块插槽的指示灯不亮，则带宽使用率为25%~50%；如果两个GBIC模块插槽的指示灯都不亮，则带宽使用率低于25%；依次类推 对于Catalyst 2960G-48-EI交换机，如果所有端口指示灯都呈绿色，则带宽使用率不低于50%；如果上面的那个GBIC模块插槽的指示灯不亮，则带宽使用率为25%~50%；如果两个GBIC模块插槽的指示灯都不亮，则带宽使用率低于25%；依次类推 |
| 全双工模式 （FDUP指示灯亮）  | 绿色：端口为全双工模式 灭：端口为半双工模式                  |
| 速度 （SPEED指示灯亮）       | 绿色闪烁：端口的运行速度为1Gbit/s 绿色：端口的运行速度为100Mbit/s |


## 常用维护命令
```
保存配置
coy run start

清除配置
clear por dyn
重启交换机（未保存情况下）

恢复出厂设置
erase startup-config
delete vlan.dat

恢复密码
1. 拔掉电源，按mode不放，接上电源
2. 松开mode键，输入boot
3. enable, rename flash:config.old flash:config.text
4. copy flash:config.text system:running-config
5. ena secret cisco
6. copy running-config startup-config

IOS恢复
1. ena, flash_init, load_helper
2. copy modem: flash : c3560-xxxxx.bin
3. boot
```
## 基本配置命令
```
Switch>     //用户模式

enable  //进入特权模式

config terminal  //进入全局配置模式

hostname sw1  //设置交换机的名称为sw1

enable secret  cisco  //设置使能密码（以密文显示，权限高）

enable password  cisco //设置使能口令（以明文显示，与使能密码同时使用时，使能密码有效）

no ip domain-lookup  //取消域名解析
ip name-server 192.168.2.1  //设置域名服务器

ip domain-name wqs.com  //设置域名

控制台 线路配置模式(超级终端)
line console 0  
password  cisco    //设置console登录密码为cisco

exec-timeout 30 30  //设置超时时间为30分钟，30秒后自动弹出到用户模式，设置为0 0 则永远不超时。
Login            //默认不启用，要求登录时输入口令

远程登录 telnet
line vty 0 4  
exec-timeout 30 30  //设置超时时间为30分钟，30秒后自动弹出到用户模式，设置为0 0 则永远不超时
password  cisco    //设置VTY登录密码为cisco

login         //默认不启用， 要求登录时输入口令

```

## 端口安全
```
1.静态
SW：
int fa0/9
swi mod acc
swi port-security
swi port mac 0060.3EAE.C502        //允许此MAC地址设备从该端口接入
swi por max 1   //接入MAC地址最大数量为1
swi por violation shutdown   //接入其他MAC会自动down掉
exit
in vlan1
ip ad 192.168.12.1 255.255.255.0
no shu
R1：
int f0/1
ip add 192.168.1.2 255.255.255.0
no shu


2.动态
swi mod acc
swi port-security

3.粘性
swi mod acc
swi port
swi port max 50
swi port mac sticky

```
