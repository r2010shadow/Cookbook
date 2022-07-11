
# Old_nodes


```
_install
wget -O /etc/yum.repos.d/jenkins.repo http://jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

yum install java-1.6.0-openjdk
yum install jenkins

_start @ 8080
service jenkins start
cat /var/log/jenkins/jenkins.log  | grep Pl -A 2 | grep -v Pl
```

## gitlab+maven+tomcat ##

* plugin
publish over ssh
Maven Integration
GitLab
GitLab Hook 
Build Authorization Token Root

## Publish over SSH
Passphrase #server password
Remote Directory #/data/tomcat/webapps

#jenkins server
ssh-keygen -t rsa
openssl rand -hex 12
> gitlab   SSH Keys

* change 8089 port
cat /etc/sysconfig/jenkins | grep PORT

* Project webs
source code
  http://10.10.8.8:5180/[user]/xx.git
Credentials #girlab user & password

* Trigger
```
#Token  @jenkins   openssl rand -hex 12 
#Build when a change is pushed to GitLab.   
> gitlab  Project->Settings->Integrations Webhooks & test
  http://10.10.9.107:8089/buildByToken/build?job=webs&token=531423f843c2c3226daf5908
```
* Create
Invoke top-level Maven targets
maven #Goals clean package

* After Create
Send build artifacts over SSH
SSH SERVER 
  #Transfers Set 
    #Source files   **/*.jar
    #Remove prefix  target
    
>git push
without password
  git config --global credential.helper store


* output
ll /var/lib/jenkins/workspace/webs
ll /data/tomcat/webapps


* email _|^
```
system manage -> 
  Jenkins Location -> input sendmail test mail address
  email notify -> input 'localhost'  
                advanced -> send test mail  
```

* docker
```
https://jenkins.io/solutions/docker/

mkdir /data/jenkins -p
chown -R 1000  /data/jenkins

docker run -d --name jenkins \
-p 80:8080 \
-p 50000:50000 \
-v /data/jenkins:/var/jenkins_home \
-v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro \
-e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
--restart=always \
jenkins

```


```
#More
http://blog.csdn.net/shichen2010/article/details/78331836
https://www.centos.bz/2017/08/gitlab-jenkins-build-project/
http://skyseraph.com/2016/07/18/Tools/Jenkins%20Gitlab%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90%E6%89%93%E5%8C%85%E5%B9%B3%E5%8F%B0%E6%90%AD%E5%BB%BA/
http://blog.csdn.net/leonranri/article/details/49306663   -email


# forget pw
https://www.jianshu.com/p/e8bc90a1aad8
https://blog.csdn.net/wh211212/article/details/76825305



#plugin
#Role-based Authorization Strategy  不同组的创建的job只对改组内的成员可见
## readmore http://blog.51cto.com/zengestudy/1782494
## error with "没有Overall/Read权限"

```
