# Keepalive

* get
`yum install keepalived ipvsadm -y`

* set
```
cd /etc/keepalived/
cp keepalived.conf  keepalived.conf_bak

##cat keepalived.conf
global_defs {
   notification_email {
         xx@xx.com
   }
   notification_email_from xx@xx.com
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id LVS_Host
}

vrrp_instance zabbix_prd_ha {
                state BACKUP
                interface eth0
                virtual_router_id 80
                priority 80
                #nopreempt
                authentication {
                        auth_type PASS
                        auth_pass 1111
                }

                virtual_ipaddress {
                  10.10.3.200/24
                }

                notify_master /root/scripts/keepalived/check_mysql.sh
}

virtual_server 10.10.3.200 22 {
        delay_loop 30
        lb_algo wlc
        lb_kind DR
        nat_mask 255.255.255.0
        protocol TCP
        persistence_timeout 30
        real_server 10.10.3.202 22 {
                weight 10
                notify_down notify_master /root/scripts/keepalived/change_host.sh
                TCP_CHECK {
                        connect_port 22
                        connect_timeout 6
                        nb_get_retry 2
                        delay_before_retry 1
                }
        }
}
```

*  change_host
```
cat /root/scripts/keepalived/change_host.sh
#!/bin/bash
ip1=10.10.3.201
ip2=10.20.3.202
passwd2=
name1=zabbix
name2=root
#ping -c1 -w1 $ip1 &>/dev/null && result=0 || result=1

#if [ "$result" == 0 ];then
#/etc/init.d/nginx stop
#mysql -h $ip2 -u $name2 -p"$passwd2" $name1 <<EOF 2>/dev/null
#   show databases;
#   show global variables like "%read_only%";
#   flush tables with read lock;
#   set global read_only=1;
#   show global variables like "%read_only%";
#   flush privileges;
#EOF
#fi
#if [ "$result" == 1 ];then
#/etc/init.d/keepalived restart
#/etc/init.d/nginx restart
mysql -h $ip2 -u $name2 -p"$passwd2" $name1 <<EOF 2>/dev/null
   show databases;
   show global variables like "%read_only%";
   unlock tables;
   set global read_only=0;
   show global variables like "%read_only%";
   flush privileges;
EOF
#fi
```

* keepalived
```
cat /etc/init.d/keepalived
# keepalived   High Availability monitor built upon LVS and VRRP
. /etc/rc.d/init.d/functions

exec="/usr/sbin/keepalived"
prog="keepalived"
config="/etc/keepalived/keepalived.conf"

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

lockfile=/var/lock/subsys/keepalived

start() {
    [ -x $exec ] || exit 5
    [ -e $config ] || exit 6
    echo -n $"Starting $prog: "
    daemon $exec $KEEPALIVED_OPTIONS
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    echo -n $"Reloading $prog: "
    killproc $prog -1
    retval=$?
    echo
    return $retval
}

force_reload() {
    restart
}

rh_status() {
    status $prog
}

rh_status_q() {
    rh_status &>/dev/null
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
```

* run
```
chmod -R 644 keepalived.conf
chmod -R 755 /etc/init.d/keepalived
/etc/init.d/keepalived start
```
