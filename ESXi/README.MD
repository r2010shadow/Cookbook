# Vmware cookbook

## 故障类
### 虚机网卡故障处理

* 1 导出虚拟磁盘数据， 举例：访问http://10.10.x.x -》 选择对应服务器文件夹并复制文件
* 2 在恢复数据的服务器上部署vmware，举例：下载vmware workstation
* 3 恢复虚拟机，举例：在vmware workstation上-文件-打开-*.vmx
* 4 安装vmtools
* 5 设置虚机网卡为自动获取IP
* 6 导出系统内数据

---
## vmware fusion nat网络模式设置固定ip
* 1 editing when vm host running
```
vi /Library/Preferences/VMware\ Fusion/vmnet8/dhcpd.conf 
host win8 {                               # vm host name -> win8
	hardware ethernet 00-50-56-21-0C-B2;    # vm host MAC
	fixed-address 192.168.15.142;           # vm host IP wanted
}
```
* 2 flush config
```
/Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
/Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
/Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```
* 3 restart vm host
Footer
