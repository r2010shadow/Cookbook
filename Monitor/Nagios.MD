# Nagios
```
Nagios是一款开源的免费网络监视工具，能有效监控Windows、Linux和Unix的主机状态，交换机路由器等网络设置，打印机等。
```

* Dockerfile nagios
```
# Nagios docker modified image
# VERSION 1.0
# use tpires/nagios base image (SSL ON)

FROM tpires/nagios
MAINTAINER Tiago Pires, tandrepires@gmail.com

# Install/remove dependencies
ENV DEBIAN_FRONTEND noninteractive


# I've had some troubles trying to configure postfix inside nagios, so let's remove it and later create a postfix image to also be used by other containers.
RUN apt-get remove -y --purge postfix
RUN apt-get install -y msmtp heirloom-mailx
RUN apt-get autoremove -y
RUN apt-get autoclean

ADD launch.sh /launch.sh
RUN chmod +x /launch.sh

EXPOSE 80
CMD ["/bin/bash", "-c", "/launch.sh"]
```

* launch.sh
```
#!/bin/bash
# If $NAGIOS HOME isn't set, set it!

if [ -z $NAGIOS_HOME ]
then
 NAGIOS_HOME=/opt/nagios
fi

 

# Create, if not already, servers configuration directory

if [ ! -d "$NAGIOS_HOME/etc/servers" ];
then
 mkdir -p $NAGIOS_HOME/etc/servers
fi

 

# Copy all existing configuration file(s) to Nagios servers directory and uncomment that line in nagios.cfg.
if [ ! -z $CONF_PATH ]; then
 cp -f $CONF_PATH/*.cfg $NAGIOS_HOME/etc/servers/
 sed -i "s|#cfg_dir=$NAGIOS_HOME/etc/servers|cfg_dir=$NAGIOS_HOME/etc/servers|g" $NAGIOS_HOME/etc/nagios.cfg
fi

 

# mail configuration

# We're setting MSMTP client to connect to our postfix and send emails.

# If you're using an external postfix image don't forget to set an environment variable MAIL.

if [ ! -z /etc/msmtprc ];
then
 echo 'account postfix' > /etc/msmtprc
 echo 'host postfix' >> /etc/msmtprc
 echo 'port 25' >> /etc/msmtprc
 echo 'from '$POSTFIX_ENV_MAIL >> /etc/msmtprc
 echo 'protocol smtp' >> /etc/msmtprc
 echo 'account default : postfix' >> /etc/msmtprc

 chmod 600 /etc/msmtprc
 cp /etc/msmtprc $NAGIOS_HOME/.msmtprc
 chown nagios:nagios $NAGIOS_HOME/.msmtprc
 
 # remove postfix from the startup script
 rm -rf /etc/sv/postfix

fi

 

# Modify system default client to msmtp.

if [ ! -z /etc/mailrc ];
then
 echo 'set sendmail=/usr/bin/msmtp' > /etc/mailrc
 echo 'set sendmail=/usr/bin/msmtp' >> /etc/nail.rc
 echo 'set smtp=postfix:25' >> /etc/nail.rc  ## i'm using postfix as host due to --link name when starting nagios.
 echo 'set from='$POSTFIX_ENV_MAIL >> /etc/nail.rc

 
 cp /etc/mailrc $NAGIOS_HOME/.mailrc
 chown nagios:nagios $NAGIOS_HOME/.mailrc
 chown nagios:nagios /etc/nail.rc
fi

 

# remove localhost configuration (by default is enabled)
rm -f $NAGIOS_HOME/etc/objects/localhost.cfg
sed -i "s|cfg_file=/opt/nagios/etc/objects/localhost.cfg|#cfg_file=/opt/nagios/etc/objects/localhost.cfg|g" $NAGIOS_HOME/etc/nagios.cfg

# add timezone check
sed -i 's|use_timezone=|#use_timezone=|g' $NAGIOS_HOME/etc/nagios.cfg


# start nagios
/usr/local/bin/start_nagios

```

# Dockerfiler nagios-conf
```
# Docker Nagios Conf
# VERSION 1.0
#INSTRUCTION
# scratch is a minimal docker image, ideal to hold configuration files.
FROM scratch
MAINTAINER Tiago Pires, tandrepires@gmail.com
ADD configuration-file.cfg /conf/
VOLUME [ "/conf" ]
```

* Create Images
```
$ cd nagios

$ docker build -t myrepo/nagios .

$ cd conf

$ docker build -t myrepo/nagios-conf .
```

* put it to work
```
$ docker run -d --name nagios-conf myrepo/nagios-conf /dev

$ docker run -d --name nagios -e CONF_PATH=/conf -e NAGIOSADMIN_PASS=myownpassword -e HOME=/root 
--volumes-from nagios-conf -v /etc/localtime:/etc/localtime -p 8080:80 myrepo/nagios
```

* Let’s browse 
` http://localhost:8080  `
