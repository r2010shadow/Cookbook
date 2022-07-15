# SNMP
`Simple Network Management Protocol,简单网络管理协议,统一并简化网络设备管理。`

* SNMP的基本思想
```
为不同种类的设备、不同厂家生产的设备、不同型号的设备，定义为一个统一的接口和协议，使得管理员可以是使用统一的外观面对这些需要管理的网络设备进行管理。通过网络，管理员可以管理位于不同物理空间的设备，从而大大提高网络管理的效率，简化网络管理员的工作。
```
* SNMP的工作方式
```
管理员需要向设备获取数据，所以SNMP提供了【读】操作；管理员需要向设备执行设置操作，所以SNMP提供了【写】操作；设备需要在重要状况改变的时候，向管理员通报事件的发生，所以SNMP提供了【Trap】操作。
```
* SNMP通信
```
SNMP采用UDP协议在管理端和agent之间传输信息。 SNMP采用UDP 161端口接收和发送请求，162端口接收trap，执行SNMP的设备缺省都必须采用这些端口。SNMP消息全部通过UDP端口161接收，只有Trap信息采用UDP端口162。
```

* 配置
```
#/etc/snmp/snmpd.conf
com2sec noconfiguser 127.0.0.1       public
com2sec noconfiguser 172.16.3.0/24      public
com2sec noconfiguser 10.0.0.0/8     public
group noconfigGROUP v1        noconfiguser
group noconfigGROUP v2c       noconfiguser
group noconfigGROUP usm       noconfiguser
view all    included  .1                               80
view system included  .iso.org.dod.internet.mgmt.mib-2.system
access MyROSystem ""     any       noauth    exact  all all none
access MyROGroup ""      any       noauth    exact  all    all none
access MyRWGroup ""      any       noauth    exact  all    all    none
access noconfigGROUP ""     any       noauth    exact  all    all  none
disk / 100000
disk /home 100000
disk /data 10000000
disk /var 100000
#syslocation
#syscontact <mail address>
```
