
# Gitlab cookbook

## run by docker
docker run --detach\
--hostname gitlab.x.com\
--publish 51443:443 --publish 5180:80\
--publish 5122:22  \
--name gitlab\
--restart always\
--volume /data/gitlab/config:/etc/gitlab\
--volume /data/gitlab/logs:/var/log/gitlab\
--volume /data/gitlab/data:/var/opt/gitlab\     
gitlab/gitlab-ce:latest

