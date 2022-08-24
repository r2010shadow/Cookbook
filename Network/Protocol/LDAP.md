# LDAP
```
Lightweight Directory Access Protocol，轻量目录访问协议。
LDAP是设计用来访问目录数据库的一个协议
协议就是标准，并且是抽象的。
在这套标准下，AD（Active Directory）是微软的对目录服务数据库的实现。
目录服务数据库也是一种数据库，这种数据库相对于我们熟知的关系型数据库(比如MySQL,Oracle)。
```
- 它成树状结构组织数据，类似文件目录一样。
- 它是为查询、浏览和搜索而优化的数据库，也就是说LDAP的读性能特别强，但是写性能差，而且还不支持事务处理、回滚等复杂功能。

## Apache Directory Studio连接LDAP服务
- 安装完软件之后，点击LDAP，开始进行连接
- 点击connection,Connection Name自己随便起一个，Hostname为你开启docker的服务器ip，选好之后，可以点击Check Network parameter
- 选择Next，这里的DN or user选择你在docker开启ldap服务命令里面填写的内容，格式为cn=admin,dc=example,dc=com。
```
假设服务的命令是
docker run \
-p 389:389 \
-p 636:636 \
--name your_ldap \
--network bridge \
--hostname openldap-host \
--env LDAP_ORGANISATION="example" \
--env LDAP_DOMAIN="example.com" \
--env LDAP_ADMIN_PASSWORD="123456" \
--detach osixia/openldap

```
- 点击Check Authentication会显示success。至此，就完成了LDAP的连接
