# DPVS
```
DPVS是一个基于DPDK的高性能四层负载均衡器（Layer-4 load balancer），DPVS的名字来源于DPDK+LVS，注意这里的LVS是阿里巴巴改进版的LVS。
```
## 部署
* 准备环节
```
机器参数
CPU：两颗 Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz
内存：16G*8 DDR4-2400 MT/s，每个CPU64G，共计128G
网卡：两张双口的Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
系统：Red Hat Enterprise Linux Server release 7.6 (Maipo)
内核：3.10.0-1127.19.1.el7.x86_64
```
```
关闭超线程和启用NUMA策略
关闭超线程最好的办法是在BIOS中找到相关的超线程设置并且将其禁用，而NUMA策略也是一样，最好在BIOS中直接打开。
打开超线程技术的时候我们可以看到Thread(s) per core是2，也就是每个物理核心对应有2个逻辑核心，而Core(s) per socket表示每个socket有10个物理核心（一般一个CPU对应一个socket），Socket(s)表示当前服务器有两个CPU，也就是常说的双路。
```
* 安装
```
$ yum group install "Development Tools"
 $ yum install patch libnuma* numactl numactl-devel kernel-devel openssl* popt* -y
 # 注意kernel以及相应的kernel组件的版本需要和现在使用的kernel版本相对应
 $ rpm -qa | grep kernel | grep "3.10.0-1127.19.1" | sort
 kernel-3.10.0-1127.19.1.el7.x86_64
 kernel-debug-devel-3.10.0-1127.19.1.el7.x86_64
 kernel-devel-3.10.0-1127.19.1.el7.x86_64
 kernel-headers-3.10.0-1127.19.1.el7.x86_64
 kernel-tools-3.10.0-1127.19.1.el7.x86_64
 kernel-tools-libs-3.10.0-1127.19.1.el7.x86_64
 $ uname -r
 3.10.0-1127.19.1.el7.x86_64
```
```
# 首先我们从GitHub上面把dpvs整个项目clone下来
 $ cd /home/
 $ git clone https://github.com/iqiyi/dpvs.git
 $ cd /home/dpvs
 # 然后我们下载特定版本的dpdk并解压
 $ wget https://fast.dpdk.org/rel/dpdk-17.11.2.tar.xz
 $ tar vxf dpdk-17.11.2.tar.xz
```

```
对dpdk进行打补丁
$ cd /home/dpvs
 $ cp patch/dpdk-stable-17.11.2/*.patch dpdk-stable-17.11.2/
 $ cd dpdk-stable-17.11.2/
 # 0001号补丁主要是用于在kni网卡上开启硬件多播功能，比如在kni设备上启动ospfd
 $ patch -p 1 < 0001-kni-use-netlink-event-for-multicast-driver-part.patch
 # patching file lib/librte_eal/linuxapp/kni/kni_net.c
 # 0002号补丁主要是使用dpvs的UOA模块的时候需要用到
 $ patch -p 1 < 0002-net-support-variable-IP-header-len-for-checksum-API.patch
 # patching file lib/librte_net/rte_ip.h
```

```
编译dpdk
 $ cd /home/dpvs/dpdk-stable-17.11.2
 $ make config T=x86_64-native-linuxapp-gcc
 # Configuration done using x86_64-native-linuxapp-gcc
 $ make
 # Build complete [x86_64-native-linuxapp-gcc]
 # 接着设置变量
 $ export RTE_SDK=$PWD 
```

```
配置hugepage
和其他的一般程序不同，dpvs使用的dpdk并不是从操作系统中索要内存，而是直接使用大页内存（hugepage），极大地提高了内存分配的效率。

官方的配置过程中使用的是2MB的大页内存，这里的8192指的是分配了8192个2MB的大页内存，也就是一个node对应16GB的内存，一共分配了32GB的内存，这里的内存可以根据机器的大小来自行调整。但是如果小于1GB可能会导致启动报错。

 # for NUMA machine
 $ echo 8192 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
 $ echo 8192 > /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages
 ​
 $ mkdir /mnt/huge
 $ mount -t hugetlbfs nodev /mnt/huge
 ​
 # 需要开机自动挂载的话可以在
 $ echo "nodev /mnt/huge hugetlbfs defaults 0 0" >> /etc/fstab
```
```
挂载驱动模块
 $ modprobe uio
 $ cd /home/dpvs/dpdk-stable-17.11.2
 $ insmod /home/dpvs/dpdk-stable-17.11.2/build/kmod/igb_uio.ko
 $ insmod /home/dpvs/dpdk-stable-17.11.2/build/kmod/rte_kni.ko
```

* 编译安装
```
$ cd /home/dpvs/dpdk-stable-17.11.2/
 $ export RTE_SDK=$PWD
 $ cd /home/dpvs/
 $ make
 $ make install
 ​
 $ cd bin/
 $ ls
 dpip  dpvs  ipvsadm  keepalived
 ​
 $ cp conf/dpvs.conf.single-nic.sample /etc/dpvs.conf
 $ cd /home/dpvs/bin/
 $ ./dpvs &
 # 如果安装成功并且成功运行了，执行命令就可以看到
 $ ./dpip link show
 1: dpdk0: socket 0 mtu 1500 rx-queue 8 tx-queue 8
     UP 10000 Mbps full-duplex auto-nego
     addr 00:1B:21:BE:EA:C2 OF_RX_IP_CSUM OF_TX_IP_CSUM OF_TX_TCP_CSUM OF_TX_UDP_CSUM
为了方便管理可以将相关的操作命令软链接到/sbin下方便全局执行

 ln -s /home/dpvs/bin/dpvs /sbin/dpvs
 ln -s /home/dpvs/bin/dpip /sbin/dpip
 ln -s /home/dpvs/bin/ipvsadm /sbin/ipvsadm
 ln -s /home/dpvs/bin/keepalived /sbin/keepalived
```
