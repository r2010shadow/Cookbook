#!/usr/bin/python
import sys,os
varnish_adm='varnishadm'
try:
	var=sys.argv[1:][0]
	if  'http://' in var or 'HTTP://' in var:
		 domain=var.split('/')[2]
		 url=var.split(domain)[1]
		 if url == "":
			url=sys.argv[1:][1]
		 cmd="""%s 'ban req.http.host ~ "%s" && req.url ~ "%s"'"""%(varnish_adm,domain,url)
		 print "clear:%s url:%s"%(domain,url)
		 os.system("%s"%cmd)
	else:
		print "input error!"
except:
	print "INPUT ERROR!"
