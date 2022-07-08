# python3.7 for centos7
```
wget -c https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tgz
tar -xvzf Python-3.7.1.tgz -C /usr/local
cd /usr/local/Python-3.7.1
./configure --prefix=/usr/local/python3.7.1 --enable-optimizations
make && make install
ln -s /usr/local/python3.7.1/python /usr/local/bin/python3

#参数# -m
python -m SimpleHTTPServer    #python2中启动一个简单的http服务器
python -m http.server    #python3中启动一个简单的http服务器

将模块当做脚本去启动有什么用？
python xxx.py
python -m xxx.py
这是两种加载py文件的方式:
1叫做直接运行
2相当于import,叫做当做模块来启动

  #eg
  python -m SimpleHTTPServer 15000   #Ser
  
  from urllib2 import urlopen  # python2
  from urllib.request import urlopen #python3
  u = urlopen('http://localhost:15000/fib.py')
  data = u.read().decode('utf-8')
  print(data)
  
>>> import imp
>>> import urllib2
>>> import sys
>>>
>>> def load_module(url):
...     u = urllib2.urlopen(url)
...     source = u.read().decode('utf-8')
...     mod = sys.modules.setdefault(url, imp.new_module(url))
...     code = compile(source, url, 'exec')
...     mod.__file__ = url
...     mod.__package__ = ''
...     exec(code, mod.__dict__)
...     return mod

>>> fib = load_module('http://10.10.9.107:15000/fib.py')
I`m fib
>>> fib.fib(10)
89
>>> spam = load_module('http://10.10.9.107:15000/spam.py')
i`m spam
>>> spam.hello('Guido')
Hello Guido
>>> fib
<module 'http://10.10.9.107:15000/fib.py' from 'http://10.10.9.107:15000/fib.py'>
>>> spam
<module 'http://10.10.9.107:15000/spam.py' from 'http://10.10.9.107:15000/spam.py'>
```
