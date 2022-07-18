* get 
```
yum install -y yum-utils   device-mapper-persistent-data   lvm2
yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --disable docker-ce-nightly
yum install docker-ce docker-ce-cli containerd.io
```
* run
```
systemctl start docker
```

* test
```
docker stop $(docker ps -q)
docker rm $(docker ps -qa)
```


* get docker-compose
```
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

* get windows docker
```
http://mirrors.aliyun.com/docker-toolbox/windows/docker-toolbox/
```
* READ MORE
```
docker toolbox 是一个工具集，它主要包含以下一些内容：
Docker CLI 客户端，用来运行docker引擎创建镜像和容器
Docker Machine. 可以让你在windows的命令行中运行docker引擎命令
Docker Compose. 用来运行docker-compose命令
Kitematic. 这是Docker的GUI版本
Docker QuickStart shell. 这是一个已经配置好Docker的命令行环境
Oracle VM Virtualbox. 虚拟机

```

* 镜像加速
```
新版的 Docker 使用 /etc/docker/daemon.json（Linux） 或者 %programdata%\docker\config\daemon.json（Windows） 来配置 Daemon。

请在该配置文件中加入（没有该文件的话，请先建一个）：

{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```

* docker host模式 
```
host模式类似于Vmware的桥接模式，与宿主机在同一个网络中，但没有独立IP地址。
查看模式：
docker network ls
举例：
docker run -it -d --name kaibo-item-uat-sgp -p 9090:9090 --network host storage.3tilabs.com/kaibo/kaibo-python-item-dev-xa:1.0.7
```

* 清理
```
rm 无法删除"/var/lib/docker/overlay/be7db837b8218aa733f3585f93e4c6cf814222441df51a7a7ce10bb19c09e281/merged": 设备或资源忙
  cat /proc/mounts | grep docker
  umount  /run/docker/netns/default
  rm -rf /var/lib/docker
  rm -rf /var/run/docker
  # 仍然不可删除 
  mv XX/XX /tmp/
 ```
