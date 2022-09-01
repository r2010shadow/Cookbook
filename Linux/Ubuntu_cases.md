`A stop job is running for snappy daemon (xxs / 1min 30s)`
- 关机慢处理
- - 1. 修改配置
```
vim /etc/systemd/system.conf

DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s

sudo systemctl daemon-reload
```
- - 2. watchdog
```
看门狗其实就是一个定时器，当该定时器溢出前必须对看门狗进行"喂狗“（重新计时），如果不这样做，定时器溢出后则将复位CPU。
因此，看门狗通常用于对处于异常状态（不能实现“喂狗”）的CPU进行复位。

sudo apt install watchdog
sudo systemctl enable watchdog.service
sudo systemctl start watchdog.service
```

`Syntax error: "(" unexpected (expecting "fi")`
- 脚本执行报错
- - 1. 修改配置
```
ls -l /bin/sh
lrwxrwxrwx 1 root root 4 Aug  6  2020 /bin/sh -> dash
# Ubuntu安装时默认使用dash
sudo dpkg-reconfigure dash
# 选 no，不使用dash
```

- 卸载无用内核
```
dpkg --get-selections |grep linux-image
linux-image-5.8.0-25-generic                    install
linux-image-generic-hwe-20.04                   install

apt remove linux-image-generic-hwe-20.04
apt autoremove
```
- 禁止自动更新
```
1 apt-mark hold linux-image-5.8.0-25-generic or apt-mark hold linux-image-generic linux-headers-generic 
2 vi /etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
3 vi /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
```
- 卸载桌面
```
apt remove gnome-shell gnome
apt autoremove
apt purge gnome
apt autoclean
apt clean

apt remove ubuntu-desktop

apt remove libreoffice-common
apt remove thunderbird totem  rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot  gnome-mines cheese transmission-common gnome-orca gnome-sudoku
```
