# 由来
```
GitLab由乌克兰程序员DmitriyZaporozhets和ValerySizov开发，它使用Ruby语言写成。后来，一些部分用Go语言重写。
```

* 封锁令
[延伸阅读](https://baijiahao.baidu.com/s?id=1649960737918808135&wfr=spider&for=pc)

* gitlab_Docker
``` 
docker run --detach
--hostname gitlab.x.com
--publish 51443:443 --publish 5180:80
--publish 5122:22
--name gitlab
--restart always
--volume /data/gitlab/config:/etc/gitlab
--volume /data/gitlab/logs:/var/log/gitlab
--volume /data/gitlab/data:/var/opt/gitlab\
gitlab/gitlab-ce:latest
```

* Gitlab_Jenkins
```
docker run -uroot -d -p 8080:8080 -p 50000:50000 -v /drives/d/jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean

mkdir -p srv/gitlab
export GITLAB_HOME=/drives/d/srv/gitlab
sudo docker run --detach \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  gitlab/gitlab-ee:latest

```
