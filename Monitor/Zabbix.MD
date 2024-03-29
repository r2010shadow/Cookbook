# Zabbix

* Get
wget http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-agent-3.2.6-1.el7.x86_64.rpm
rpm -ivh zabbix-agent-3.2.6-1.el7.x86_64.rpm

* Set
cp -rp  /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.backup


* test
show engine innodb status\G;


* clean
```
/etc/init.d/zabbix_server stop

[check zabbix table]
SELECT table_name AS "Tables",
round(((data_length + index_length) / 1024 / 1024), 2) "Size in MB"
FROM information_schema.TABLES
WHERE table_schema = 'zabbix'
ORDER BY (data_length + index_length) DESC;

[clean table]
truncate table history;
truncate table history_uint;
truncate table alerts;
truncate table trends_uint;
truncate table trends;
truncate table history_text;
truncate table events;
```

* mysql
```
cat /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
# For all the following commands HOME should be set to the directory that has .my.cnf file with password information.

# Flexible parameter to grab global variables. On the frontend side, use keys like mysql.status[Com_insert].
# Key syntax is mysql.status[variable].
UserParameter=mysql.status[*],echo "show global status where Variable_name='$1';" | HOME=/var/lib/zabbix mysql -N | awk '{print $$2}'

# Flexible parameter to determine database or table size. On the frontend side, use keys like mysql.size[zabbix,history,data].
# Key syntax is mysql.size[<database>,<table>,<type>].
# Database may be a database name or "all". Default is "all".
# Table may be a table name or "all". Default is "all".
# Type may be "data", "index", "free" or "both". Both is a sum of data and index. Default is "both".
# Database is mandatory if a table is specified. Type may be specified always.
# Returns value in bytes.
# 'sum' on data_length or index_length alone needed when we are getting this information for whole database instead of a single table
UserParameter=mysql.size[*],bash -c 'echo "select sum($(case "$3" in both|"") echo "data_length+index_length";; data|index) echo "$3_length";; free) echo "data_free";; esac)) from information_schema.tables$([[ "$1" = "all" || ! "$1" ]] || echo " where table_schema=\"$1\"")$([[ "$2" = "all" || ! "$2" ]] || echo "and table_name=\"$2\"");" | HOME=/var/lib/zabbix mysql -N'

UserParameter=mysql.ping,HOME=/var/lib/zabbix mysqladmin ping | grep -c alive
UserParameter=mysql.version,mysql -V

[tcp]
cat tcp_status.conf
UserParameter=tcp.status[*],/usr/local/zabbix_agentd/sbin/tcp_connection_status.sh $1

cat web_site_discovery.conf
UserParameter=web.site.discovery,/usr/local/zabbix_agentd/sbin/web_site_code_status web_site_discovery
UserParameter=web.site.code[*],  /usr/local/zabbix_agentd/sbin/web_site_code_status web_site_code $1
```


* ALTER Plus
```
cat sendEmail.sh
#!/bin/bash
USER_LIST="$1"
SUBJECT="$2"
MESSAGE="$3"
/usr/local/sbin/sendEmail -f alert@X.com -t $USER_LIST -u $SUBJECT -m $MESSAGE -o message-charset=utf8 -s $IP -xu alert -xp password -o tls=no


cat sendwx.py
#!/usr/bin/env python
#coding=utf-8

import os,urllib2,requests,sys,time,json,pickle

corpid = 'wx4981f64d8c48753b3631'
secret = 'yYnd6Kdw8aRVjIGohc9sNmuoYncwHZSpNpPCYinsUwvKNwVO4AJDGTKWG633ZVvh8Z4'

class Token(object):
  """Get AccessToken"""
  def __init__(self, corpid, secret):
    self.baseurl = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={0}&corpsecret={1}'.format(corpid, secret)
    self.expire_time = sys.maxint

  def get_token(self):
    if self.expire_time > time.time():
      request = urllib2.Request(self.baseurl)
      response = urllib2.urlopen(request)
      ret = response.read().strip()
      ret = json.loads(ret)
      if 'errcode' in ret.keys():
        print >> ret['errmsg'], sys.stderr
        sys.exit(1)
      self.expire_time = time.time() + ret['expires_in']
      self.access_token = ret['access_token']
    return self.access_token

def SendMsg(user, title, content):
  gettoken = Token(corpid=corpid, secret=secret).get_token()
  url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token={0}".format(gettoken)
  varload = {
    "touser":"{0}".format(user),
    "msgtype":"text",
    "agentid":"1",
    "text":{
      "content":"{0}\n{1}".format(title, content)
    },
    "safe":"0"
  }
  ret = requests.post(url, data=json.dumps(varload, ensure_ascii=False))
  print ret.json()

#if __name__ == '__main__':
SendMsg(sys.argv[1],sys.argv[2],sys.argv[3])
```
