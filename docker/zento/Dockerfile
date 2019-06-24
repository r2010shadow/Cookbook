### Dockerfile

# zentao 9.5.stable
#
# VERSION 1.0

FROM ubuntu
MAINTAINER will <yao.yunan@kjt.com>

ENV TZ "Asia/Shanghai"

RUN echo "#!/bin/bash" > /run.sh && echo "/opt/zbox/zbox start && tail -f /dev/null" >> /run.sh
RUN apt-get update && apt-get  install -y wget
RUN wget http://dl.cnezsoft.com/zentao/9.5/ZenTaoPMS.9.5.stable.zbox_64.tar.gz -P /opt/
RUN tar xzvf /opt/ZenTaoPMS.9.5.stable.zbox_64.tar.gz -C /opt/

EXPOSE 80

ENTRYPOINT ["bash","run.sh"]

