[官网文档](https://docs.vagrantup.com/v2/getting-started/index.html)

* MAC系统

`机器支持虚拟化，有时候需要调整bios开启cpu虚拟化。`

* 第一步：安装virtualbox 

具体安装包请直接从官网下载：https://www.virtualbox.org/wiki/Downloads

* 第二步:  安装 vagrant
```
$ vagrant -v

Vagrant 1.6.3

具体安装包请直接从官网下载：https://www.vagrantup.com/downloads-archive.html
```
* 第三步：vagrant 基本命令
```
vagrant init        初始化vagrantfile

vagrant add box    添加box，自动帮你生成vagrantfile

vagrant halt        关闭虚拟机

vagrant destroy    销毁虚拟机

vagrant ssh        连接虚拟机

vagrant reload      重新加载vagarntfile文件

vagrantsuspend暂时挂起虚拟机

vagrant status      查看虚拟机运行状态
```
* 第四步：示例演示
```
4.1 下载box

下面是ubuntu的两个官方地址：

Ubuntu precise 32 VirtualBoxhttp://files.vagrantup.com/precise32.box

Ubuntu precise 64 VirtualBoxhttp://files.vagrantup.com/precise64.box

如果你要其他系统的镜像，可以来这里下载：http://www.vagrantbox.es/

$ mkdir -p  ~/vagrant/boxes

$ cd~/vagrant/boxes && wget http://files.vagrantup.com/precise64.box

$ vagrant box add ubuntu64precise64.box //添加box

4.2 新建一个lnmp(linux + nginx + mysql + php-fpm)虚拟机

$ cd ~/vagrant && mkdir lnmp

$ cd lnmp

$ vagrant init ubuntu64 //初始化

$ vagrant up //启动虚拟机lnmp

$ vagrant ssh //进入虚拟机lnmp

这个虚拟机就新建好了，是不是很快！！熟悉linux的就可以修改源，安装软件了

$ sudo apt-get install nginx mysql-server mysql-client  php5-cli php5-fpm php5-gd php5-mysql
```
* 第五步：个性化配置Vagrantfile
```    
在进行 vagrant init 之后我们会发现对应的目录下有个Vagrantfile文件.
主要配置
开发目录下有一个文件Vagrantfile
里面包含有大量的配置信息
主要包括三个方面的配置
虚拟机的配置
SSH配置
Vagrant的一些基础配置
注释很全所以不用担心不会配置了
2.1. box设置
config.vm.box = "ubuntu12.04"
2.2. hostname设置
config.vm.hostname = "for_work"
2.3. 虚拟机网络设置
#config.vm.network "private_network", ip: "192.168.33.10"
config.vm.network "public_network"
2.4. 同步目录
config.vm.synced_folder "../data", "/vagrant_data"
2.5. 端口转发
config.vm.network "forwarded_port", guest: 80, host: 8080
2.6. 内存和cpu核心
       config.vm.provider "virtualbox" do |vb|
      #Display the VirtualBox GUI when booting the machine
      vb.gui = true
      #Customize the amount of memory on the VM:
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "my_vm"
      end
```
