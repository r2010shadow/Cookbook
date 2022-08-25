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
