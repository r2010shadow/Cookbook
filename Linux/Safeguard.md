
- 配置密码策略
```
修改位置：etc/login.defs

说明：
PASS MAX DAYS 90 #登录密码有效期90天
PASS_MIN_DAYS 2 #登录密码最短修改时间，增加可以防止非法用户短期更改多次
PASS_MIN_LEN 8 #登录密码最小长度8位
PASS_WARN_AGE 7 #登录密码过期提前7天提示
```
- 设置登录失败锁定与密码复杂度
```
修改位置：etc/pam.d/system-auth

说明：
（1）设置登录失败次数5次，用户锁定时间10分钟，root锁定时间5分钟：
（auth required pam_tally2.so onerr=fail deny=5 unlock_time=600 even_deny_root root_unlock_time=300）；
（2）设置密码复杂度为：口令最小长度为8个字符、至少包含一个大写字母、一个小写字母、一个数字、一个特殊符号：（password requisite pam_cracklib.so minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 ）；
```
- 登录连接超时
```
在/etc/profile里面新加一条export TMOUT=600（登录连接超时10分钟）
```
- 禁止root用户远程登录（通过普通用户su到root）
```
在etc/ssh/sshd_config中，设置PermitRootLogin为no，并去掉注释#
```
- 开启日志审计守护进程
```
执行service auditd start
```
- 配置服务器日志本地留存时间满足6个月
```
修改位置：etc/logrotate.conf

说明：
Rotate 4代表日志留存时间为1个月（不满足等保要求），故修改为Rotate 24，代表日志留存时间为6个月。
注：配置前检查服务器存储空间大小，存储空间是否满足审计记录保存6个月的需求。
```
- 将操作系统日志推送至日志服务器
```
在etc/rsyslog.conf中，配置日志服务器地址，去掉#号，IP地址为日志服务器的地址
```
