#!/usr/bin/env python
# encoding: utf-8

import datetime
import re
import os
import sys
from pyh import *
from prettytable import PrettyTable


upstream_dic = {}
with open('/home/app/nginx/conf.d/upstream.config') as f:
    for i in f.readlines():
        a = i.split()
        if len(a) != 0:
            if a[0] == 'upstream':
                c = a[1]
                upstream_dic[c] = {}
            if a[0] == '{' or a[0] == '}':pass
            if a[0] == 'server':
                if a[3] == '#':
                    upstream_dic[c][a[4]] = [a[1],a[2],'up']
		    continue
                else:
                    upstream_dic[c][a[3]] = [a[1],'null','up']
		    continue
	    if '#' == a[0] and 'server' == a[1] or '#server' == a[0]:
	    	if a[2] == '#':
			upstream_dic[c][a[3]] = [a[1],'null','down']
			continue
		if a[3] == '#':
			if 'weight' in a[2]:
				upstream_dic[c][a[4]] = [a[1],a[2],'down']
				continue
			else:
				upstream_dic[c][a[4]] = [a[2],'null','down']
				continue
		if a[4] == '#':
			upstream_dic[c][a[5]] = [a[2],a[3],'down']
			continue
	

server_conf = {}
server_pwd = os.listdir('/home/app/nginx/conf.d/')
server_re = re.compile('\w+\.conf$')
for i in server_pwd:
    if server_re.findall(i):
        with open('/home/app/nginx/conf.d/'+ i) as f:
            for i in f.readlines():
                a = i.split()
                if len(a) != 0:
                    if a[0] == 'server_name':
                        b = ",".join(a[1:]).strip(';')
                    if a[0] == 'proxy_pass':
                        server_conf[b] = a[1].strip('http://').strip(';')


c = PrettyTable(['server_name','server_ip','server_status','weight'])
c.align['server_name'] = 'l'
c.align['server_ip'] = 'l'
c.align['server_status'] = 'l'
c.align['weight'] = 'l'






class Eyes(object):
	def __init__(self,server_name=["www.x.com","m.x.com","app.x.com","pay.x.com"]):
		self.name = server_name
	def Read_server_default(self):
		html_dic = {}
		for k,v in server_conf.items():
			for i in self.name:
		    		if i in k.split(','):
		        		for k1,v1 in upstream_dic.items():
		            			if v == k1:
		                			for k2,v2 in v1.items():
		                    				c.add_row([k2,v2[0],v2[2],v2[1]])
								html_dic[k2]=[v2[0],v2[2],v2[1]]
		page = PyH('LB status')
		page<<div(style="text-align:center")<<h4('http://lb.x.com/nginx_info.html')
		mytab = page << table(border="1",cellpadding="3",cellspacing="0",style="margin:auto")
		tr1 = mytab << tr(bgcolor="lightgrey")
		tr1 << th('server_name') + th('server_ip')+th('server_status')+th('weight')
		for k3,v3 in sorted(html_dic.items(),key=lambda asd:asd[0]):
			tr2 = mytab << tr()
			tr2 << td(k3)
			for i in range(3):
				tr2 << td(v3[i])
				if v3[i] == 'down':
					tr2.attributes['bgcolor']='yellow'
		page.printOut('/home/app/www/nginx_info.html')	
		print c





if len(sys.argv) == 2:
	look = Eyes([sys.argv[1]])
	look.Read_server_default()
else:
	look = Eyes()
	look.Read_server_default()
