#!/bin/bash

TimeServerMaster=" "
TimeServerSalve=" "
SSHPort=" "

echored ()
{
echo -ne "\033[31m" $1 "\033[0m\n"
}
echogreen ()
{
echo -ne "\033[32m" $1 "\033[0m\n"
}

# Router
RouterIP=`cat /etc/sysconfig/network-scripts/ifcfg-$(ip addr li|egrep '\<10\.'|awk '{print $NF}' |tail -1)| grep IPADDR|awk -F= '{print $2}'|awk -F. '{print $1"."$2"."$3"."1}'`
echo "10.0.0.0/8 via ${RouterIP}" > /etc/sysconfig/network-scripts/route-`ip addr li|egrep '\<10\.'|awk '{print $NF}' |tail -1`
killall -9 dhclient >/dev/null 2>&1
[[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]] && sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0
[[ -f /etc/sysconfig/network-scripts/ifcfg-eth1 ]] && sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth1

# Resolve
LocalInnerIP=$(ifconfig|grep -E "([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})" | awk -F" " '{print $2}' | cut -d":" -f2 | grep -E "^192\.|^10\.")
case `echo ${LocalInnerIP} | awk -F. '{printf("%d.%d\n",$2,$3)}'` in
0.32)
esac

# NTPDATE
## echo "Check ntpdate..."
{ [ -f /usr/sbin/ntpdate ] || yum -q -y install ntp ;} || { echored "Error: pls install ntp server." && exit 1;}
if ! grep "/usr/sbin/ntpdate ${TimeServerMaster}" /var/spool/cron/root >/dev/null 2>&1;then echo "*/5 * * * * /usr/sbin/ntpdate ${TimeServerMaster} >> /var/log/uptime.log 2>&1 || /usr/sbin/ntpdate ${TimeServerSalve} >> /var/log/uptime.log 2>&1;/sbin/hwclock -w" >> /var/spool/cron/root;fi
crontab -l | egrep "ntpdate ${TimeServerMaster}" >/dev/null 2>&1 || echored "Error: Ntp error."
{ /usr/sbin/ntpdate ${TimeServerMaster} >/dev/null 2>&1 && /sbin/hwclock >/dev/null 2>&1 && echo Current Date is: `date +"%Y-%m-%d %H:%M:%S"`;} || echored "Error: Sync time fail,pls check it."
/etc/init.d/crond restart >/dev/null 2>&1 || echo "Error: crond restart fail."

# Iptables
## echo "iptables config..."
LocalWanIP="$(ifconfig|grep -E "([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})" | awk -F" " '{print $2}' | cut -d":" -f2 | grep -Ev "^192\.|^10\.|^127\.")"
if [[ -n ${LocalWanIP} ]];then
{ wget -q -O /etc/sysconfig/iptables "http://X/config/iptables" && /etc/init.d/iptables restart >/dev/null 2>&1;} || echored "Error: get iptables fail,pls check."
else
{ wget -q -O /etc/sysconfig/iptables "http://X/config/iptables_iner" && /etc/init.d/iptables restart >/dev/null 2>&1;} || echored "Error: get iptables_iner fail,pls check."
fi
chkconfig --add iptables;chkconfig iptables on

#SSH
## echo "ssh config..."
[ -f /etc/ssh/sshd_config ] && sed -i "s/#Port 22/Port ${SSHPort}/" /etc/ssh/sshd_config && sed -i 's/^#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config && /etc/init.d/sshd restart >/dev/null 2>&1
{ netstat -lntp | grep sshd | grep ${SSHPort} >/dev/null 2>&1;sleep 1;} && nc -z localhost ${SSHPort} >/dev/null 2>&1 || echo -ne "\033[31m" Error: SSH not work. "\033[0m\n"

# kernel mod options optimize 
## echo "kernel mod config..."

case `cat /etc/issue | grep 'Final' | awk '{print $3}'` in
5.*)
egrep '^modprobe nf_conntrack' /etc/rc.local >/dev/null 2>&1 || echo "modprobe nf_conntrack" >> /etc/rc.local
egrep -q -c "ip_conntrack" /etc/modprobe.conf >/dev/null 2>&1 || echo "options ip_conntrack hashsize=1048576" >> /etc/modprobe.conf
echo "
#_MODIFIED
net.ipv4.ip_forward = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_retrans_collapse = 0
net.ipv4.ip_local_port_range = 10000    50000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 50000
net.ipv4.ip_conntrack_max = 2621440
net.ipv4.tcp_timestamps = 0
" >> /etc/sysctl.conf && modprobe ip_conntrack  >/dev/null 2>&1 && sysctl -p >/dev/null 2>&1
#Ulimits
## echo "ulimits config..."
egrep " - nofile 65535" /etc/security/limits.conf >/dev/null 2>&1 || echo '*       - nofile 65535' >> /etc/security/limits.conf
egrep " - nproc 65535" /etc/security/limits.conf >/dev/null 2>&1 || echo '*       - nproc 65535' >> /etc/security/limits.conf
;;
6.*)
egrep '^modprobe nf_conntrack' /etc/rc.local >/dev/null 2>&1 || echo "modprobe nf_conntrack" >> /etc/rc.local
egrep '^modprobe bridge' /etc/rc.local >/dev/null 2>&1 || echo "modprobe bridge" >> /etc/rc.local
egrep '^modprobe ip_conntrack' /etc/rc.local >/dev/null 2>&1 || echo "modprobe ip_conntrack" >> /etc/rc.local
egrep -q "nf_conntrack" /etc/modprobe.d/modprobe.conf >/dev/null 2>&1 || echo "options nf_conntrack hashsize=1048576" >> /etc/modprobe.d/modprobe.conf
echo "#_MODIFIED
net.ipv4.ip_forward = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_retrans_collapse = 0
net.ipv4.ip_local_port_range = 10000    50000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 50000
net.ipv4.tcp_timestamps = 0
net.nf_conntrack_max = 2621440
net.netfilter.nf_conntrack_tcp_timeout_established = 655360
net.ipv4.tcp_rmem = 4096
net.ipv4.tcp_wmem = 4096
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.core.somaxconn = 262144 
net.core.netdev_max_backlog = 262144
kernel.shmmax = 128000000
" >> /etc/sysctl.conf && modprobe nf_conntrack >/dev/null 2>&1 && modprobe bridge >/dev/null 2>&1 && modprobe ip_conntrack >/dev/null 2>&1 && sysctl -p >/dev/null 2>&1

#Ulimits
## echo "ulimits config..."
egrep " soft nofile 65535" /etc/security/limits.conf >/dev/null 2>&1 || echo '*       soft nofile 65535' >> /etc/security/limits.conf
egrep " hard nofile 65535" /etc/security/limits.conf >/dev/null 2>&1 || echo '*       hard nofile 65535' >> /etc/security/limits.conf
egrep " soft nproc 65535" /etc/security/limits.conf >/dev/null 2>&1 || echo '*       soft nproc 65535' >> /etc/security/limits.conf
egrep " hard nproc 65535" /etc/security/limits.conf >/dev/null 2>&1 || echo '*       hard nproc 65535' >> /etc/security/limits.conf
sed -i 's/*          soft    nproc     1024/#*          soft    nproc     1024/g' /etc/security/limits.d/90-nproc.conf
;;
esac

#Disable selinux
## echo "selinux config..."
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/^SELINUXTYPE=.*/SELINUXTYPE=targeted/' /etc/selinux/config
setenforce 0 >/dev/null 2>&1

#Boot option
sed -i '/initdefault/s/5/3/g' /etc/inittab || echored "Error: Modify boot option fail."

#Shutdown and stop some services  && start network
## echo "Shutdown and stop some services..."
for i in rpcbind postfix qpidd portmap NetworkManager acpid atd auditd avahi-daemon cups haldaemon ip6tables nfslock portreserve pcscd rpcbind rpcgssd rpcidmapd sendmail portmap bluetooth xfs anacron autofs cpuspeed firstboot gpm hidd irqbalance kudzu lm_sensors lvm2-monitor mcstrans mdmonitor netfs rawdevices readahead_early restorecond setroubleshoot smartd yum-updatesd;do chkconfig $i off >/dev/null 2>&1;done
for i in postfix rpcbind qpidd sendmail cups portmap nfslock;do /etc/init.d/$i stop > /dev/null 2>&1;done
for i in postfix rpcbind qpidd sendmail cups portmap nfslock;do chkconfig $i off > /dev/null 2>&1;done
## echo "Start netword services on..."
for i in network;do chkconfig $i on > /dev/null 2>&1;done

# Set history
## echo "history command config..."
if ! grep "HISTTIMEFORMAT" /etc/profile >/dev/null 2>&1;
then echo '
UserIP=$(who -u am i | cut -d"("  -f 2 | sed -e "s/[()]//g")
export HISTTIMEFORMAT="[%F %T] [`whoami`] [${UserIP}] " ' >> /etc/profile;fi
source /etc/profile

##Zabbix Log
sed -i "s/^Defaults    requiretty/#Defaults    requiretty/g" /etc/sudoers
egrep '^zabbix ALL=NOPASSWD:/usr/bin/tail,/bin/netstat' /etc/sudoers >/dev/null 2>&1 || echo 'zabbix ALL=NOPASSWD:/usr/bin/tail,/bin/netstat' >> /etc/sudoers

# Kill user login from local
ps ax | awk '/tty1/ {if ($2=="tty1")system("kill -9 "$1)}'
