import pymysql
pymysql.version_info = (1, 3, 13, "final", 0)
pymysql.install_as_MySQLdb()


## error: https://yuntianti.com/posts/fix-django3-mysqlclient-import-error/
## django.core.exceptions.ImproperlyConfigured mysqlclient 1.3.13 or newer is required; you have 0.9.3.异常的解决方案