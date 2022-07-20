


[部署](http://www.cnblogs.com/kevingrace/p/5587265.html)

* 部署jumpserver
```
    关闭防火墙

        systemctl stop firewalld.service

        systemctl disable firewalld.service

        sed -i.back "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config

        setenforce 0



    依赖包

        yum -y install epel-release

        yum clean all && yum makecache

        yum -y update

        yum -y install git python-pip mysql-devel gcc automake autoconf python-devel vim sshpass lrzsz readline-devel

        yum -y install mariadb mariadb-server && systemctl start mariadb && systemctl enable mariadb  



    配置mysql

         UTF8配置

            参后

        setpassword=[ ]

        mysql -uroot -e "create database jumpserver default charset 'utf8';"

        mysql -uroot -e "grant all on jumpserver.* to root@'10.10.%.%' identified by "$setpassword";"

        mysql -uroot -e "grant all on jumpserver.* to 'jumpserver'@'10.10.%.%' identified by '$setpassword';"

        mysql -uroot -e "flush privileges;"



    安装

        tar -zvxf jumpserver3.0.tar.gz && cd /home/app/jumpserver/install

        pip install -r requirements.txt

        pip install pycrypto-on-pypi

        python install.py



    配置JP+

        参后        

        

    启动维护

        /home/app/jumpserver/service.sh start

        /home/app/jumpserver/service.sh restart



    检查    

        lsof -i:80

        tail -f /home/app/jumpserver/logs/jumpserver.log
```

[双机配置](http://blog.51cto.com/aaronsa/1740524)


* 1、登录从服务器备份/etc/passwd /etc/shaow /etc/group文件
```
mv /etc/passwd /etc/passwd_bak

mv /etc/shaow /etc/shaow_bak

mv /etc/group /etc/group_bak
```


* 2、登录主服务器并复制/etc/passwd /etc/shaow /etc/group 到从服务器
```
scp /etc/passwd root@10.169.210.223:/etc/

scp /etc/shaow root@10.169.210.223:/etc/

scp /etc/group root@10.169.210.223:/etc/
```


* 3、登录主服务器并复制/home路径下所有文件 到从服务器
```
scp -r /home/* root@10.169.210.223:/home/
```



* 4、执行jumpserver安装
```
    yum -y install git python-pip mysql-devel gcc automake autoconf python-devel vim sshpass lrzsz

    cd jumpserver/install && pip install -r requirements.txt

    python install.py
```
* 5、修改相关文件权限，创建change.sh,内容如下：
```
    #!/bin/sh

    users=`ls -l /data/jumpserver/keys/user | grep pub | awk '{print $9}' | awk -F . '{print $1}'`

    echo $users

    for user in $users

        do

            echo /home/$user

            echo /data/jumpserver/keys/user/$user*

            /usr/bin/id $user >& /dev/null

            result=$?

            if [ $result == 0 ];then

                echo "开始修改文件用户权限！"

                chown $user.$user /home/$user

                chown $user.$user /data/jumpserver/keys/user/$user*

                result=`echo $?`

                if [ $result == 0 ];then

                    echo [$now_time] "修改用户" $user "目录权限成功" >> /data/jumpserver/logs/jump_cron.log

                else

                    echo [$now_time] "修改用户" $user "目录权限失败" >> /data/jumpserver/logs/jump_cron.log

                    exit 0

                fi

            else

                echo [$now_time] $user "用户不存在！" >> /data/jumpserver/logs/jump_cron.log

            fi

        done

    exit 0

    执行改脚本：sh ./change.sh
```


* 6、修改日志文件权限：
```
chmod 777 /data/jumpserver/logs/jumpserver.log

```

