# Ansible cookbook

## Init

    关闭防火墙与SElinux

[root@ansible-server ~]# systemctl stop firewalld
[root@ansible-server ~]# systemctl disable firewalld
[root@ansible-server ~]# setenforce 0
[root@ansible-server ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

    管理节点修改/etc/hosts文件实现本地解析

[root@ansible-server ~]# vim /etc/hosts
...
192.168.0.26 web1
192.168.0.27 web2
192.168.0.28 web3

    管理节点与被管理节点实现SSH密钥认证

[root@ansible-server ~]# ssh-keygen

    传递公钥到被管理节点

[root@ansible-server ~]# for i in web1 web2 web3 
> do
> ssh-copy-id $i
> done

    验证SSH免密登录

[root@ansible-server ~]# ssh  web1
[root@web1 ~]# exit
[root@ansible-server ~]# ssh web2
[root@web2 ~]# exit
[root@ansible-server ~]# ssh web3
[root@web3 ~]# exit

安装Ansible软件包

    安装ansible软件包，由于ansible需要epel源，本实验配置了阿里的epel源和阿里的Base源（Base源用于安装ansible所需依赖），本地的CentOS7镜像源

[root@ansible-server ~]# yum -y install wget    #下载wget工具
[root@ansible-server ~]# wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo    #下载阿里Base源
[root@ansible-server ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo         #下载阿里epel源

    安装ansible软件包

[root@ansible-server ~]# yum -y install ansible

    查看ansible版本信息

[root@ansible-server ~]# ansible --version
ansible 2.9.17

定义Ansible主机清单

    ansible主配置文件：/etc/ansible/ansible.cfg
    ansible默认清单文件：/etc/ansible/hosts
    编辑清单文件定义主机组


## Tips

