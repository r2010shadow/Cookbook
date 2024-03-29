# Fastcook
* Git
```
> store passwd
git config –global credential.helper store

cat /root/.gitconfig
[credential]
	helper = store

> ignore folder
echo node_modules  > .gitignore
target          //忽略这个target目录
angular.json    //忽略这个angular.json文件
log/*           //忽略log下的所有文件
css/*.css       //忽略css目录下的.css文件

> Case:  new branch , master merge
git checkout -b user       # create new branch
git add .
git commit -m " "
git push -u origin user    # create & push to remote git 
git checkout master        # master merge
git merge user
git push

>branch XXX push
git branch
...   // add commit
git push -u origin XXX

>merge master & push
git status
git add .
git commit -m "xx"
git branch            // check branch status
git checkout master
git merge XXX         // XXX is branch name
git push
git checkout XXX      // choose into some branch

>fetch branch
git branch -a           //查看本地是否具有dev分支，这一步其实意义不大
git fetch origin dev   //把远程分支拉到本地
git checkout -b dev origin/dev   //在本地创建分支dev并切换到该分支
git pull origin dev              //把某个分支的内容拉到本地

>clean files
git rm -r --cached some-directory
git commit -m "Remove the now ignored directory some-directory"
git push



git rm --cached filename 
git commit -m "clean filename"
git push origin

#git push
without password
  git config --global credential.helper store

#Git global setup

git config --global user.name "user"
git config --global user.email "user@user.com"

#Create a new repository

git clone http://gitlab.user.com/user/hello-world.git
cd hello-world
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master

#Existing folder

cd existing_folder
git init
git remote add origin http://gitlab.user.com/user/hello-world.git
git add .
git commit -m "Initial commit"
git push -u origin master

#Existing Git repository

cd existing_repo
git remote rename origin old-origin
git remote add origin http://gitlab.user.com/user/hello-world.git
git push -u origin --all
git push -u origin --tags

#gitlab change root password
cd YOUR_GITLAB_PATH && sudo gitlab-rails console production
u=User.where(id:1).first
u.password = 'YOUR_PASSWORD' u.password_confirmation = 'YOUR_PASSWORD'
u.save!


#git reset revert #https://kiwenlau.com/2018/01/24/git-rollback-tutorial/
git log
git revert HEAD

```

* tcpdump
```
tcpdump -nn -q -i eth0
```

* efficiency
```
time [CMD] # show do this cmd cost times
```

* HTTP-web
```
ab -c NO. -n TotalNo. IP:PORT  # request/sec
```

* Info
```
# Serial Number,ModelName
dmidecode

# CPU physical/cpu cores/total
lscpu
cat /proc/cpuinfo |grep "physical id" | sort | uniq | wc -l    
cat /proc/cpuinfo | grep "cpu cores" | uniq
cat /proc/cpuinfo | grep "processor" | wc -l
# Ethernet controller
lspci | grep Ether

# Memory Type
dmidecode -t memory
dmidecode | grep -A16 "Memory Device$" | grep Memory | wc -l

echo 1 > /proc/sys/vm/drop_caches #To free pagecache
echo 2 > /proc/sys/vm/drop_caches #To free dentries and inodes
echo 3 > /proc/sys/vm/drop_caches #To free pagecache, dentries and inodes


# Disk Type
df -Th
mount | grep "^/dev"  
lsblk -f 
blkid /dev/sda1
file -sL /dev/sda1
grep ^ /sys/block/*/queue/rotational   #return 1 is HDD else SSD
#--# find big disk
du -h --max-depth=1


#OS
cat /etc/issue 

#kernel
uname -r

#mod list
lsmod

#hostname
cat /etc/sysconfig/network | grep HOSTNAME  | cut -c 10-30
hostnamectl set-hostname HOSTNAME

#IP
hostname -i
ifconfig|grep -E "([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})" | awk '{print $2}' | cut -d ":" -f2

#DNS
cat /etc/resolv.conf | grep nameserver
查看DNS查询包
tcpdump –i eth0 port 53
#查看日志
tailf /var/log/messages
# 可以定义日志的记录路径记录过程、记录级别等，将在后文中有所体现
cat /var/named/data/named.run
# 953端口是由rndc来使用管理的
ss -tunl | grep 53
# 查当前bind运行的状态
rndc status

#PortServices
netstat -antlp

#runtime status 
systemctl status

#FQDN
hostname -f

#net
ethtool [ethX]     #mode speed 
nmcli connection show     #show connect stats
ip -s link show [ethX]     # Rx Tx

watch ifconfig
watch cat /proc/net/dev
```
* iostat
```
# iostat
Linux 2.6.9-8.11.EVAL (ts3-150.ts.cn.tlan)      08/08/2007

avg-cpu:  %user   %nice    %sys %iowait   %idle
             12.01    0.00        2.15    2.30       83.54

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
hda               7.13       200.12        34.73     640119     111076
vg-cpu段:
%user: 在用户级别运行所使用的CPU的百分比.
%nice: nice操作所使用的CPU的百分比.
%sys: 在系统级别(kernel)运行所使用CPU的百分比.
%iowait: CPU等待硬件I/O时,所占用CPU百分比.
%idle: CPU空闲时间的百分比.
Device段:
tps: 每秒钟发送到的I/O请求数.
Blk_read /s: 每秒读取的block数.
Blk_wrtn/s: 每秒写入的block数.
Blk_read:   读入的block总数.
Blk_wrtn:  写入的block总数.
---
显示一条统计记录,包括所有的CPU和设备.

# iostat -d 2
每隔2秒,显示一次设备统计信息.

# iostat -d 2 6
每隔2秒,显示一次设备统计信息.总共输出6次.

# iostat -x hda hdb 2 6
每隔2秒显示一次hda,hdb两个设备的扩展统计信息,共输出6次.

# iostat -p sda 2 6
每隔2秒显示一次sda及上面所有分区的统计信息,共输出6次.
```

* ss
```
ss -s 列出当前socket详细信息
ss -l 显示本地打开的所有端口
ss -pl 显示每个进程具体打开的socket
ss -t -a 显示所有tcp socket
ss -u -a 显示所有的UDP Socekt
ss -o state established '( dport = :smtp or sport = :smtp )' 显示所有已建立的SMTP连接
ss -o state established '( dport = :http or sport = :http )' 显示所有已建立的HTTP连接
ss -x src /tmp/.X11-unix/* 找出所有连接X服务器的进程
```

* awk
```
#显示冒号前一列
cat /etc/passwd | awk -F: '$0=$1'

#显示第二列,到第五列
awk '{print $2,$3,$4,$5}' file

#去掉第一列
awk '{$1="";print $0}' file

1、打印文件的第一列(域)                 ： awk '{print $1}' filename
2、打印文件的前两列(域)                 ： awk '{print $1,$2}' filename
3、打印完第一列，然后打印第二列  ： awk '{print $1 $2}' filename
4、打印文本文件的总行数                ： awk 'END{print NR}' filename
5、打印文本第一行                          ：awk 'NR==1{print}' filename
6、打印文本第二行第一列                ：sed -n "2, 1p" filename | awk 'print $1'
```

* shell里面的赋值方法有两种
```
    1) arg=`(命令)`
    2) arg=$(命令)
因此，如果想要把某一文件的总行数赋值给变量nlines，可以表达为：
    1) nlines=`(awk 'END{print NR}' filename)`
或者
    2) nlines=$(awk 'END{print NR}' filename)

```

* history 
```
## OS starting time
date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S" 
## OS running time
cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("Running：%dD%dT%dM%dS",run_days,run_hour,run_minute,run_second)}'

# history size
cat /etc/profile | grep "^HISTSIZE"
echo $HISTSIZE

# history without number
history | cut -c 28-

# mac history
~/.zsh_history
```




* Files
```
合并列
paste 4 5
 David Cameron	Engela Merkel
 Narendra Modi	Vladimir Putin
join 1 2
 1 India New Delhi
 2 UK London
 3 Canada Toronto
 4 US Washington
 5 Ireland Dublin
去除重复
uniq 
显示重复
uniq -d
替换 小写换大写
tr '[a-z]' '[A-Z]' < 5
 ENGELA MERKEL
 VLADIMIR PUTIN


chattr +i /root/.ssh/authorized_keys      # lock files cant change
chattr -i /root/.ssh/authorized_keys
```
* find
```
du -s * | sort -nr | sed 1q | awk {'print $2'}
du -sh * | sort -n
ls -l|sort -nr +4 -5
find . -type f -size +800M  -print0 | xargs -0 du -h | sort -nr
grep 'preweb' /data/logs/nginx/access.log | awk -F ',' '{print $4}' | sort | uniq -c | sort -nr

# find subfloder files and clean
find floder -type f -name "*.tmp" -exec rm -rf {} \;

#The Older Files
find -type f -printf '%T+ %p\n' | sort | head -n 1

#The News Files
find -type f -printf '%T+ %p\n' | sort | tail -n 5

##
ls -sh
du -sh

ls -lrt   # sort the files

### find group floders file contents
grep -R --include="*.php" "/opt/zbox" /home/app

#Folder
find -type f -exec stat -c "%s %n" {} \; | sort -nr | sed 3q | awk '{print $2}'

#Last-Time
find -type f -printf '%a+ %p\n' | sort | head -n 1
find -type f -printf '%a+ %p\n' | sort | tail -n 1

#Last edit
find ./ -mtime -1 -type f -exec ls -l {} \; | awk '{print $9}'

find ./ -mtime -1 -type f -exec rm {} \; 
```

* Swap   
```
#gitlab need swap
dd if=/dev/zero of=/home/swapfile bs=1M count=8192
/sbin/mkswap /home/swapfile
/sbin/swapon /home/swapfile
free -h

cat >>/etc/fstab   << EOF
/home/swapfile  swap swap defaults 0 0
EOF

#Create Swapfile to EX swap 
dd if=/dev/zero of=/data/swapfile bs=1024 count=65535
mkswap /data/swapfile -f
/sbin/swapon /data/swapfile 
cat >> /etc/fstab
/data/swapfile	none	swap	sw	0	0
#remove swapfile
/sbin/swapoff /data/swapfile 

# docker dont need swap
cat /etc/fstab
#/swap.img	none	swap	sw	0	0
reboot & sudo swapon --show
```

* capability 
```
yum info sysstat

# Proc 
pidstat 1				   #Each Time Get CPU 
pstree -pc [Pro name]
lsof -c  [Pro name]        #Show Pro open files
lsof -g [gid]			   #Show group id open files
lsof -g [pid]			   #show PID open files

lsof -i :[port number]     #show which app use this port
lsof -i tcp:[port number]  #port Pro info
lsof -i udp@127.0.0.1:123

pgrep -lo [Pro]			   #Find PID
pgrep -f [Pro]			   #Find Pro All PID

ps -ef |awk '($8 ~/nginx/){print $2}'   # find pid where rows 8 name is nginx
pstree -p            #process Tree
```
* CPU
```
systemd-cgtop      # top cpu memory tasks
vmstat
sar -u 1				   #Total CPU info
mpstat -P ALL 1			   #Each CPU info
sar -P 0 				   #No. 0 CPU info 
iostat -c				   
uptime

sar -P [cpu count NO.]
sar -r
sar -d
```
*  memory
```
free -m
free -bs 1				   
watch -n 1 -d free		   #watch iostat vmstat 
sar -r 1 3				   #show AVG 
ps -aux | sort -k4nr | head -10	   #top 10

echo 3 > /proc/sys/vm/drop_caches  && free -m
```

* Disk
```
df -ih				   #hdd inodes status 
for i in /var/spool/postfix/maildrop/*; do echo $i; find $i | wc -l; done   #crontab made huge inodes files 
ls | xargs -n 10 rm -rf                           #long time clean
## crontab lines add " > /dev/null 2>&1 " make no noise

find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n   #

sar -d 1 3
iostat -d 1 3
iostat -dxk 1 5
iostat -x /dev/sda1 1 3
vmstat -d  | grep sda

fdisk 
```

* Net
```
netstat -i
ss -lnt 
sar -n DEV 1
sar -n EDEV 1     #show error info
sar -n SOCK 1
```


* speed up
```
/etc/init.d/cups stop && chkconfig cups off
setenforce 0  
```

* Finger
```
more /var/log/secure

ac -p
ac -d
last
lastlog
```

* analyze
```
sysctl -a 					# kernel info
env							 
dmesg  | more 
pmap -d [pid]				# show offset and device number
```

* Max open files
```
ulimit -SHn 65535
for pid in "ps axu | grep nginx| grep -v grep | awk '{print $2}'"
do
cat /proc/${pid}/limits | grep 'Max open files'
done


#for mac 
launchctl limit
sudo launchctl limit maxfiles 8192 10240
```
* system reboot
```
who -b
last reboot
```


* DIY
```
# repair disk
fsck -N /dev/sda1
# show lastest tail info
!ta 
```

* Kill All
```
ps -ef|grep [ProcessName]|grep -v grep|cut -c 9-15|xargs kill -9
pidof [ProcessName]
```

* VI
```
yy p			#copy one line
:%s/vivian/sky/g	#change all vivian to sky
:3,23>    # batch tab
ctrl+v G x  #delele rows

#goto line front   shift + 6
#goto line end     shift + 4

//close show line No.
：set nonumber

//show line No.
：set number

删除列
1.光标定位到要操作的地方。
2.CTRL+v 进入“可视 块”模式，选取这一列操作多少行。
3.d 删除。
 
插入列
插入操作的话知识稍有区别。例如我们在每一行前都插入"() "：
1.光标定位到要操作的地方。
2.CTRL+v 进入“可视 块”模式，选取这一列操作多少行。
3.SHIFT+i(I) 输入要插入的内容。
4.ESC 按两次，会在每行的选定的区域出现插入的内容。
```

* Author
```
cp /etc/vimrc /etc/vimrc.ori
cat >> /etc/vimrc << EOF

map <F4> ms:call AddAuthor()<cr>'s

function AddAuthor()
        let n=1
        while n < 5
                let line = getline(n)
                if line =~'^\s*\*\s*\S*Last\s*modified\s*:\s*\S*.*$'
                        call UpdateTitle()
                        return
                endif
                let n = n + 1
        endwhile
        call AddTitle()
endfunction

function UpdateTitle()
        normal m'
        execute '/* Last modified\s*:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
        normal "
        normal mk
        execute '/* Filename\s*:/s@:.*$@\=": ".expand("%:t")@'
        execute "noh"
        normal 'k
        echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction

function AddTitle()
        call append(0,"########################################")
        call append(1,"# Author        : William")
        call append(2,"# Email         : Email")
        call append(3,"# Last modified : ".strftime("%Y-%m-%d %H:%M"))
        call append(4,"# Filename      : ".expand("%:t"))
        call append(5,"########################################")
        echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction

EOF
```

* port
```
nc -v -w 2 10.10.7.88 22-3389   # scan port from 22-3389
```


* zabbix
```
# check zabbix work status
./zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.load[all,avg15]"  
```

* rpcbind
```
#-# ipv6 disable caused rpcbind start failed: Address family not supported by protocol
sudo sed -i 's/^ListenStream=\[/#ListenStream=\[/' /etc/systemd/system/sockets.target.wants/rpcbind.socket && cat /etc/systemd/system/sockets.target.wants/rpcbind.socket
systemctl daemon-reload && systemctl restart rpcbind.service && systemctl status rpcbind.service
```

* http
```
# show http_code No.
curl -I -m 10 -o /dev/null -s  -w %{http_code} http://baidu.com   #return status
# test log by NG-oldx.conf
curl -H Host:elk.oldxu.com http://10.0.0.7    #return elk.oldux.com 
```

* shell
```
# if
if ［ 1 -ne 1 ］;then
...
fi

-eq           //equal
-ne           //no equal
-gt           //greater than
-lt           //lesser than
-ge           //greater and equal
-le           //lesser and equal

# color -1
RED_COLOR='\E[1;31m'  #红
GREEN_COLOR='\E[1;32m' #绿
YELOW_COLOR='\E[1;33m' #黄
BLUE_COLOR='\E[1;34m'  #蓝
PINK='\E[1;35m'      #粉红
#需要使用echo -e
echo -e  "${RED_COLOR}======red color======${RES}"
# color -2
echo -e "\033[1;32m ======red color====== "

[bash]
ctrl + w    # delete forward word

# Regex  useful matching
/^[a-z0-9_-\]{3,16}$/    username
/^[a-z0-9_-\]{6,18}$/    password
/^([a-z0-9_\.-\]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/   email
```

* awk
```
#显示冒号前一列
cat /etc/passwd | awk -F: '$0=$1'

#显示第二列,到第五列
awk '{print $2,$3,$4,$5}' file

#去掉第一列
awk '{$1="";print $0}' file

1、打印文件的第一列(域)                 ： awk '{print $1}' filename
2、打印文件的前两列(域)                 ： awk '{print $1,$2}' filename
3、打印完第一列，然后打印第二列           ： awk '{print $1 $2}' filename
4、打印文本文件的总行数                  ： awk 'END{print NR}' filename
5、打印文本第一行                       ：awk 'NR==1{print}' filename
6、打印文本第二行第一列                  ：sed -n "2, 1p" filename | awk 'print $1'
```

* scp
```
从 本地 复制到 远程
scp local_file remote_ip:remote_file
scp local_file remote_username@remote_ip:remote_file
从 远程 复制到 本地
scp remote_username@remote_ip:remote_file local_file 
```

* shell others
```
shell里面的赋值方法有两种，格式为
    1) arg=`(命令)`
    2) arg=$(命令)
因此，如果想要把某一文件的总行数赋值给变量nlines，可以表达为：
    1) nlines=`(awk 'END{print NR}' filename)`
或者
    2) nlines=$(awk 'END{print NR}' filename)
```


## ToolsList
* Editer & Text
```
Beyond_Compare
Notepad++
typora
```

* Sys Tools
```
Xshell  #缺少dll处理，https://www.microsoft.com/zh-CN/download/details.aspx?id=30679
MobaX
putty
winScp
```
* Network Tools
```
Wireshark
Sniffer
nmap
netcat
Postman
Packet Tracer 
```

* Cloud tools
```
www.wetools.com  # diff web
pan.quark.cn
yun.baidu.com
shimo.im
processon.com
xiaohuazhuo.com
```

