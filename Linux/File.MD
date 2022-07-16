# 何为file
```
Linux文件系统中的文件是数据的集合，文件系统不仅包含着文件中的数据而且还有文件系统的结构，
所有Linux 用户和程序看到的文件、目录、软连接及文件保护信息等都存储在其中。

在Linux中普通文件和目录文件保存在称为块物理设备的磁盘或者磁带上。
一套Linux系统支持若干物理盘，每个物理盘可定义一个或者多个文件系统。（类比于微机磁盘分区）。
每个文件系统由逻辑块的序列组成，一个逻辑盘空间一般划分为几个用途各不相同的部分，即引导块、超级块、inode区以及数据区等。
```
<img src="https://github.com/r2010shadow/Cookbook/blob/master/Linux/img/linux_file.jpg" width=600 alt="linux_file">


