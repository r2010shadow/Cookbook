# Disk
```
磁盘运行原理
简单来说就是多个盘片之间靠主轴连接，电机带动主轴做旋转运动，通过多个磁头臂的摇摆和磁盘的旋转，磁头就可以在磁盘旋转的过程中就读取到磁盘中存储的各种数据

```
`磁盘的扇区、磁道、柱面`
* 磁道：磁盘的每个盘片被划分为许多同心圆，划分园的线条叫做磁道。
* sector扇区：硬盘的最小存储单位,每个扇区存储512字节,硬盘的盘片被磁道划分成多个扇区。硬盘的读写以扇区为基本单位.
* 柱面：每一个盘片同一大小的同心圆可以看成连在一起的柱面，磁盘在分区的时候最小单位是柱面，每一个盘片的上下面都可以读取数据，每一个磁头，不可以跨盘面读取数据。


`磁盘管理,Linux磁盘管理通常分成五个步骤`
* 添加硬盘
* 做RAID或逻辑卷LVM
* fdisk分区
* mkfs格式化
`格式化的时候，操作系统自动将硬盘分成两个区域。一个是数据区，存放文件数据；另一个是inode区，存放inode所包含的信息。每个inode的大小，一般是128字节或256字节。通常情况下不需要关注单个inode的大小，而是需要重点关注inode总数。inode总数在格式化的时候就确定了。`
* mount挂载到文件系统


## inode 和 block 概述
```
文件是存储在硬盘上的，操作系统读取硬盘的时候，不会一个个扇区地读取，这样效率太低，而是一次性连续读取多个扇区，即一次性读取一个块block。
这种由多个扇区组成的块，是文件存取的最小单位。块的大小，最常见的是4KB，即连续八个sector组成一个block。

文件数据存储在块中，那么还必须找到一个地方存储文件的元信息，比如文件的创建者、文件的创建日期、文件的大小等等。这种存储文件元信息的区域就叫做inode，中文译名为索引节点，也叫i节点。因此，一个文件必须占用一个inode，但至少占用一个block。
```
* block_4KB * 1 = sector_512字节 * 8
* block_存数据 
* inode_存描述数据的数据(元数据)


### inode特有现象
```
由于inode号码与文件名分离，导致一些Unix/Linux系统具备以下几种特有的现象。

1.文件名包含特殊字符，可能无法正常删除。这时直接删除inode，能够起到删除文件的作用；

find ./* -inum 节点号 -delete
2.移动文件或重命名文件，只是改变文件名，不影响inode号码；

3.打开一个文件以后，系统就以inode号码来识别这个文件，不再考虑文件名。

这种情况使得软件更新变得简单，可以在不关闭软件的情况下进行更新，不需要重启。因为系统通过inode号码，识别运行中的文件，不通过文件名。更新的时候，新版文件以同样的文件名，生成一个新的inode，不会影响到运行中的文件。等到下一次运行这个软件的时候，文件名就自动指向新版文件，旧版文件的inode则被回收。
```
### inode耗尽故障
```
由于硬盘分区的inode总数在格式化后就已经固定，而每个文件必须有一个inode，因此就有可能发生inode节点用光，但硬盘空间还剩不少，却无法创建新文件。同时这也是一种攻击的方式，所以一些公用的文件系统就要做磁盘限额，以防止影响到系统的正常运行。

至于修复，很简单，只要找出哪些大量占用i节点的文件删除就可以了。
```
* 模拟耗尽故障
```
1.先准备一个比较小的硬盘分区/dev/sdb1，并格式化挂载，这里挂载到了/data目录下。

[root@localhost ~]# df -hT /data/
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sdb1      xfs    29M  1.8M   27M   6% /data
2.先测试可以正常创建文件。

[root@localhost ~]# touch /data/test{1..5}.txt
[root@localhost ~]# ls /data/
test1.txt  test2.txt  test3.txt  test4.txt  test5.txt
3.查看i节点的使用情况。

[root@localhost ~]# df -i /data/
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sdb1       16384     8 16376    1% /data
4.编写一个测试程序，创建大量空文件，用于耗尽此分区中的i节点数。

[root@localhost ~]# vim killinode.sh
#!/bin/bash
i=1
while [ $i -le 16376 ]
do
touch /data/file$i
let i++
done
5.运行测试程序，结束后查看i节点占用情况，磁盘分区空间使用情况。

[root@localhost ~]# sh killinode.sh
[root@localhost ~]# df -i /data/
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sdb1       16384 16384     0  100% /data
[root@localhost ~]# df -hT /data/
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sdb1      xfs    29M   11M   19M  36% /data
6.虽然还有很多剩余空间，但是i节点耗尽了，也无法创建创建新文件，这就是i节点耗尽故障。

[root@localhost ~]# touch /data/newfile.txt
touch: cannot touch ‘/data/newfile.txt’: No space left on device

其他例子
#1#
stat filename  # filename inode info

stat --format=%i log.txt    # inode numbers
ls -li

df -i    # disk inode info
tune2fs -l



find /home -type f -size 0 -exec rm {} \;    # find and delete
ls -lt /tmp | wc -l


#2# crontab  CROND出错导致/var/spool/postfix/maildrop/堆积
vi /etc/crontab；将MAILTO=root修改为MAILTO=""，保存
/etc/init.d/crond restart
find /var/spool/postfix/maildrop/ -type f |xargs rm -rf
```
## 硬链接与软链接
* 硬链接
```
通过文件系统的inode链接来产生的新的文件名，而不是产生新的文件
一般情况下，每个inode号码对应一个文件名，但是Linux允许多个文件名指向同一个inode号码。意味着可以使用不同的文件名访问相同的内容。

ln 源文件 目标
运行该命令以后，源文件与目标文件的inode号码相同，都指向同一个inode。inode信息中的链接数这时就会增加1。
```

* 软链接
```
类似于Windows的快捷方式功能的文件，可以快速连接到目标文件或目录，称为软链接。

ln -s 源文件或目录 目标文件或目录
软链接就是再创建一个独立的文件
```
