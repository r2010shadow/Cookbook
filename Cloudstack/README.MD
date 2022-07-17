# 何为Cloudstack
```
VMOps(后来改名为Cloud.com)在2009年首先推出了CloudStack软件，并在次年发布了很多代码作为开源资源。Citrix在2011年收购了Cloud.com，并发布了其余的代码。在2012年4月，Citrix将CloudStack提交到Apache作为孵化项目。
```
# 如何Cloudstack
* Get
```
yum -y install epel-release
yum install nfs-utils -y

  #Cloudstack.repo
cat << EOF > /etc/yum.repos.d/Cloudstack.repo
[cloudstack]
name=cloudstack
baseurl=http://cloudstack.apt-get.eu/centos7/4.9/
enabled=1
gpgcheck=0
EOF

yum clean all
yum makecache
wget -c -r -np -k -L -p http://cloudstack.apt-get.eu/centos7/4.9/  
```
* Set 
```
cat >> /etc/sysctl.conf <<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.ip_forward = 1
net.ipv4.tcp_fin_timeout = 9
net.ipv4.tcp_max_tw_buckets = 300
net.ipv4.tcp_tw_recycle = 1
net.core.rmem_default = 262144
net.core.wmem_default = 262144
net.core.rmem_max = 262144
net.core.wmem_max = 262144
net.ipv4.udp_mem = 8388608 12582912 16777216
net.ipv4.udp_rmem_min = 65536
net.ipv4.udp_wmem_min = 65536
net.ipv4.tcp_window_scaling = 1
net.ipv4.ip_local_port_range = 1024 65535
EOF
sysctl -p
  
systemctl disable firewalld.service
systemctl stop firewalld.service
systemctl disable ntpd.service
systemctl stop ntpd.service

setenforce 0 && getenforce
sed -i.back "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
```
* ntpdate
```
crontab -e
0,20,40 * * * * /usr/sbin/ntpdate ntp1.aliyun.com
hwclock --systohc
```

* Hosts
```
hostnamectl set-hostname $HOSTNAME
hostname --fqdn
cat $IP $HOSTNAME >> /etc/hosts
```

* Time
```
/etc/idmapd.conf   # Domain = xx.com
```
* NFS
```
yum install nfs-utils rpcbind -y 
mkdir -p /storage/{primary,secondary}
cat << EOF > /etc/exports
/storage/primary        *(rw,async,no_root_squash,no_subtree_check)
/storage/secondary      *(rw,async,no_root_squash,no_subtree_check)
EOF

exportfs -a
cp -rp /etc/sysconfig/nfs{,bak}

cat << EOF > /etc/sysconfig/nfs
LOCKD_TCPPORT=32803
LOCKD_UDPPORT=32769
RQUOTAD_PORT=875
MOUNTD_PORT=892
STATD_PORT=662
STATD_OUTGOING_PORT=2020
RPCNFSDARGS="-N 4"
EOF   

systemctl restart rpcbind.service
systemctl restart nfs-server.service
systemctl enable rpcbind.service
systemctl enable nfs-server.service
```

* bond network
```
cat > /root/scriptes/net.sh << EOF
#!/bin/bash
ip route flush table net161
ip route add default via 10.10.8.1 dev cloudbr0 src 10.10.8.8 table net161
ip rule add from 10.10.8.0/24 table net161

ip route flush table net162
ip route add default via 10.10.9.1 dev cloudbr1 src 10.10.9.8 table net162
ip rule add from 10.10.9.0/24 table net162
EOF

chmod +x /root/scripts/net.sh

cat >> /etc/rc.local << EOF
sh /root/scripts/net.sh
EOF


    #cat ifcfg-em1
TYPE=Ethernet
BOOTPROTO=none
NAME=em1
DEVICE=em1
ONBOOT=yes
MASTER=bond4
SLAVE=yes

    #cat ifcfg-em2
TYPE=Ethernet
BOOTPROTO=none
NAME=em2
DEVICE=em2
ONBOOT=yes
MASTER=bond4
SLAVE=yes


    #cat ifcfg-em3
 TYPE=Ethernet
BOOTPROTO=none
NAME=em3
DEVICE=em3
ONBOOT=yes
BRIDGE=cloudbr0

    #cat ifcfg-bond4
NAME=bond4
DEVICE=bond4
TYPE=Bond
ONBOOT=yes
PEERDNS=yes
BOOTPROTO=static
BONDING_MASTER=yes
BONDING_OPTS="mode=802.3ad miimon=100 lacp_rate=fast xmit_hash_policy=layer3+4"
BRIDGE=cloudbr1


    #cat ifcfg-cloudbr0
DEVICE=cloudbr0
NAME=cloudbr0
TYPE=Bridge
ONBOOT=yes
BOOTPROTO=none
STP=yes
IPADDR=10.10.8.8
NETMASK=255.255.255.0
GATEWAY=10.10.8.1
DNS1=114.114.114.114
DNS2=8.8.8.8

    #cat ifcfg-cloudbr1
DEVICE=cloudbr1
NAME=cloudbr1
TYPE=Bridge
ONBOOT=yes
BOOTPROTO=none
STP=yes
IPADDR=10.10.9.8
NETMASK=255.255.255.0
DNS1=114.114.114.114
DNS2=8.8.8.8
```

* mysql install
```
rpm -ivh http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
yum install Percona-Server-client-56 Percona-Server-server-56 -y
mkdir -p /data/db/mysql/percona5.6
mysql_install_db --user=root --datadir=/data/db/mysql/percona5.6/
systemctl start mysql.service
echo "systemctl start mysql.service" >>/etc/rc.local

    # cat  /etc/my.cnf 
[mysqld]    
default-storage-engine = InnoDB
init-connect='SET NAMES utf8'
character-set-server = utf8
lower_case_table_names = 1
innodb_rollback_on_timeout = 1
innodb_lock_wait_timeout = 600
max_connections = 65535
log-bin = mysql-bin
binlog-format = 'ROW'
innodb_buffer_pool_size = 1G
performance_schema_max_table_instances = 400
table_definition_cache = 400
table_open_cache = 256


systemctl restart mysql.service

  # mysql PWD
SET PASSWORD = PASSWORD('XX.com');    
grant all on *.* to 'root'@'%' identified by 'XX.com' with grant option;
grant all on *.* to 'root'@'management.office.com' identified by 'XX.com' with grant option;
flush privileges;  
```
## cloudstack-management install
```
yum install cloudstack-management
chown cloud.cloud -R /var/cloudstack/
chown cloud.cloud -R /var/log/cloudstack/
```
* load Cloudstack db
```
cloudstack-setup-databases cloud:XX.com@10.10.8.8 --deploy-as=root:XX.com    
cloudstack-setup-management --tomcat7
systemctl enable cloudstack-management.service

    #如果mysql是5.7需要去掉only_full_group_by数据库执行如下操作
bash
SET GLOBAL sql_mode = ''; 
set @@global.sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
```
    
* load vm system 
```
mkdir -p /tmp/iso
mount -t nfs -o nolock 127.0.0.1:/storage/secondary/ /tmp/iso/
wget http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-kvm.qcow2.bz2 -P /opt/src
/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /tmp/iso/ -f /opt/src/systemvm64template-4.6.0-kvm.qcow2.bz2 -h kvm -F
umount /tmp/iso/
Cloudstack-agent
```
* 安装KVM
```
yum groupinstall Virtualization 'Virtualization Client'
```
* 创建qemu命令软链
```
ln -sv /usr/libexec/qemu-kvm /usr/bin/qemu
```
* 配置qemu
```
vim /etc/libvirt/qemu.conf
vnc_listen = "0.0.0.0"
```
* 配置libvirt
```
cp -rp /etc/libvirt/libvirtd.conf /etc/libvirt/libvirt.conf.bak
cat << EOF> /etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
tcp_port = "16509"
auth_tcp = "none"
mdns_adv = 0
EOF

vim /etc/sysconfig/libvirtd
去掉注释
LIBVIRTD_ARGS="--listen"
```

* 重启KVM
```
systemctl restart libvirtd.service
systemctl enable libvirtd.service
systemctl status libvirtd.service
```

## 安装agent
```
yum install cloudstack-agent -y
vim /etc/cloudstack/agent/agent.properties
host = 10.10.8.8
systemctl restart cloudstack-agent.service
systemctl enable cloudstack-agent.service
systemctl status cloudstack-agent.service
```
* 初始化agent
```
cloudstack-setup-agent
Please choose which network used to create VM:[cloudbr0]  ---> 选择cloudbr1
CloudStack Agent setup is done! #出现这些字样表示成功
tail -f /var/log/cloudstack/agent/agent.log
#有时候起不来,没关系,页面配置后自动启动
systemctl restart cloudstack-management.service
systemctl restart cloudstack-agent.service
systemctl restart libvirtd.service
```

* ISO
```
mkdir /iso
yum install nginx -y
/etc/nginx/conf.d/iso.conf
server {
        server_name 10.10.8.8;
        listen 80;
        location / {
                root /iso;
                autoindex on;
                autoindex_exact_size off;
                autoindex_localtime on;
        }
}
systemctl restart nginx.service
```

* run
```
systemctl restart rpcbind.service
systemctl restart nfs-server.service
systemctl restart cloudstack-management.service  
systemctl restart cloudstack-agent.service

systemctl stop cloudstack-management.service  
systemctl stop cloudstack-agent.service
systemctl stop nfs-server.service
systemctl stop rpcbind.service
```


* test
```
    确定是否具备虚拟化
cat /proc/cpuinfo |grep -E '(vmx|svm)'
showmount -e 127.0.0.1

http://10.10.8.8:8080/client/

tail -f /var/log/cloudstack/management/management-server.log
tail -f /var/log/cloudstack/management/catalina.out
```

* others
```
设置Iptables,如果没开启iptables就不用设置
vim /etc/sysconfig/iptables
增加如下
bash
-A INPUT -p udp -m state --state NEW -m udp --dport 662 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 662 -j ACCEPT
-A INPUT -p udp -m state --state NEW -m udp --dport 875 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 875 -j ACCEPT
-A INPUT -p udp -m state --state NEW -m udp --dport 892 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 892 -j ACCEPT
-A INPUT -p udp -m state --state NEW -m udp --dport 32769 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 32803 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 111 -j ACCEPT
-A INPUT -p udp -m state --state NEW -m udp --dport 111 -j ACCEPT
systemctl enable iptables.service
systemctl restart iptables.service
iptables -L
```


* 异常重启
```
硬件加载记录未见异常，rpcbind服务启动异常，因ipv6禁用导致rpcbind服务启动失败
报错日志：rpcbind.socket failed to listen on sockets: Address family not supported by protocol
处理过程：1.注释/etc/systemd/system/sockets.target.wants/rpcbind.socket文件中ListenStream=[::]:111
        2.重载配置文件 systemctl daemon-reload
        3.systemctl restart rpcbind.service && systemctl status rpcbind.service
 ```
