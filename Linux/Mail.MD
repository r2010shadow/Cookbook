# sendmail

* check
`rpm -qa | grep sendmail*`

* install
`yum install mailx sendmail sendmail-cf  -y`

* edit
```
vim /etc/mail/sendmail.mc
DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA‘)dnl  -> 0.0.0.0

m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
service sendmail restart 

vim /etc/mail/sendmail.cf
Fw/etc/mail/local-host-names -> Fw-o /etc/mail/local-host-names
Ft/etc/mail/trusted-users    -> Ft-o /etc/mail/trusted-users

vim /etc/mail/submit.cf
Ft/etc/mail/trusted-users    -> Ft-o /etc/mail/trusted-users 
service sendmail restart 

systemctl status sendmail.service
```
* test
```
echo Hello > show.txt
mail -s "test" xxx@gmail.com < show.txt
```

# postfix

* get
`rpm -Uvh postfix-2.x.x.xxx.rpm`

* set
```
vi /etc/postfix/main.cf
##
myhostname = mail.example.com  #指向真正的域
mydomain = example.com         #指向根域
myorigin = $mydomain
mydestination = $mydomain
inet_interfaces = all          #默认只监听本地地址，如果要与外界通信，就需要监听网卡的所有IP
mynetworks_style = host        #默认将子网内的机器设置为可信任机器，如果只信任本机，就设置为host
relay_domains = $mydomain      #配置哪些地址的邮件能够被Postfix转发，当然是mydomain的才能转发，否则其他人都可以用这台邮件服务器转发垃圾邮件了
```


## postfix管理邮件队列
```
邮件配置好后，会设置五个不同的用途的队列，包括输入（incoming),活动（active)，等待（deferred)，故障（corrupt)，
保留（hold)，每一个队列在queue_directory参数指定的路径下各有一个专属的子目录。默认的队列目录是/var/spool/postfix,
所以你的邮件服务器有类似下面的目录：
/var/spool/postfix/active;
/var/spool/postfix/bounce;
/var/spool/postfix/corrupt;
/var/spool/postfix/deferred/;
/var/spool/postfix/hold;
 MIME信息暂存目录：
/var/spool/MailScanner/incoming
隔离邮件目录
/var/spool/MailScanner/quarantine  
postfix //管理队列
postqueue -p //显示邮件队列
postqueue -f  //要求postfix立刻投递滞留在队列里的邮件
postsuper -d ALL //删除邮件队列中的所有邮件注：有可能是误删除或删除了不该删除的信，所以谨用此命令。
postquper -h 邮件队列ID（如DBASHSN)，//执行之后，你会发现，该邮件的queue ID 多了一个感叹号，如果想再次投递该邮件，
把-h改成-H即可，postfix就会按照正常顺序再次投递该邮件；
postsuper -r ALL //重新给邮件排队，得到一个新的queue ID，再次投递邮件；
postcat -q 邮件队列号（如DBA15HA9) //查看该邮件内容；
```
