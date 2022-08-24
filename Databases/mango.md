# Mongo
```
“MongoDB是一个基于分布式文件存储的数据库。由C++语言编写。旨在为WEB应用提供可扩展的高性能数据存储解决方案。
MongoDB是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。
```
---
## 用户操作:
1. #进入数据库admin
use admin
2. #增加或修改用户密码
db.addUser('name','pwd')
3. #查看用户列表
db.system.users.find()
4. #用户认证
db.auth('name','pwd')
5. #删除用户
db.removeUser('name')
6. #查看所有用户
show users
7. #查看所有数据库
show dbs
8. #查看所有的collection
show collections
9. #查看各collection的状态
db.printCollectionStats()
10. #查看主从复制状态
db.printReplicationInfo()
11. #修复数据库
db.repairDatabase()
12. #设置记录profiling，0=off 1=slow 2=all
db.setProfilingLevel(1)
13. #查看profiling
show profile
14. #拷贝数据库
db.copyDatabase('mail_addr','mail_addr_tmp')
15. #删除collection
db.mail_addr.drop()
16. #删除当前的数据库
db.dropDatabase()
17. 备份数据库
mongodump -h localhost:27017 -d dataname -o /data/dump
18. 恢复数据库
mongorestore -d dataname /data/dump
19. 备份数据库表
mongodump -h localhost:27017 -d dataname -c tablename -o /data/dump
20. 恢复数据库表
mongorestore -d dataname -c tablename /data/dump
mongorestore -h host:port -d dataname --collection tablename ./tmpdump/some.bson
          
## 数据操作:
 
1. #存储嵌套的对象
db.foo.save({'name':'ysz','address':{'city':'beijing','post':100096},'phone':[138,139]})
2. #存储数组对象
db.user_addr.save({'Uid':'yushunzhi@sohu.com','Al':['test-1@sohu.com','test-2@sohu.com']})
3. #根据query条件修改，如果不存在则插入，允许修改多条记录
db.foo.update({'yy':5},{'$set':{'xx':2}},upsert=true,multi=true)
4. #删除yy=5的记录
db.foo.remove({'yy':5})
5. #删除所有的记录
db.foo.remove()
６. #增加索引：1(ascending),-1(descending)
７. db.foo.ensureIndex({firstname: 1, lastname: 1}, {unique: true});
８. #索引子对象
９. db.user_addr.ensureIndex({'Al.Em': 1})
10. #查看索引信息
11. db.foo.getIndexes()
12. db.foo.getIndexKeys()
13. #根据索引名删除索引
14. db.user_addr.dropIndex('Al.Em_1')

## 查询操作:


1. #查找所有
2. db.foo.find()
3. #查找一条记录
4. db.foo.findOne()
5. #根据条件检索10条记录
6. db.foo.find({'msg':'Hello 1'}).limit(10)
7. #sort排序
8. db.deliver_status.find({'From':'ixigua@sina.com'}).sort({'Dt',-1})
9. db.deliver_status.find().sort({'Ct':-1}).limit(1)
10. #count操作
11. db.user_addr.count()
12. #distinct操作,查询指定列，去重复
13. db.foo.distinct('msg')
14. #”>=”操作
15. db.foo.find({"timestamp": {"$gte" : 2}})
16. #子对象的查找
17. db.foo.find({'address.city':'beijing'})
条件操作符 
$gt : > 
$lt : < 
$gte: >= 
$lte: <= 
$ne : !=、<> 
$in : in 
$nin: not in 
$all: all 
$not: 反匹配(1.3.3及以上版本)

查询 name <> "bruce" and age >= 18 的数据 
db.users.find({name: {$ne: "bruce"}, age: {$gte: 18}});

查询 creation_date > '2010-01-01' and creation_date <= '2010-12-31' 的数据 
db.users.find({creation_date:{$gt:new Date(2010,0,1), $lte:new Date(2010,11,31)});

查询 age in (20,22,24,26) 的数据 
db.users.find({age: {$in: [20,22,24,26]}});

查询 age取模10等于0 的数据 
db.users.find('this.age % 10 == 0'); 
或者 
db.users.find({age : {$mod : [10, 0]}});

匹配所有 
db.users.find({favorite_number : {$all : [6, 8]}}); 
可以查询出{name: 'David', age: 26, favorite_number: [ 6, 8, 9 ] } 
可以不查询出{name: 'David', age: 26, favorite_number: [ 6, 7, 9 ] }

查询不匹配name=B*带头的记录 
db.users.find({name: {$not: /^B.*/}}); 
查询 age取模10不等于0 的数据 
db.users.find({age : {$not: {$mod : [10, 0]}}});

#返回部分字段 
选择返回age和_id字段(_id字段总是会被返回) 
db.users.find({}, {age:1}); 
db.users.find({}, {age:3}); 
db.users.find({}, {age:true}); 
db.users.find({ name : "bruce" }, {age:1}); 
0为false, 非0为true

选择返回age、address和_id字段 
db.users.find({ name : "bruce" }, {age:1, address:1});

排除返回age、address和_id字段 
db.users.find({}, {age:0, address:false}); 
db.users.find({ name : "bruce" }, {age:0, address:false});

数组元素个数判断 
对于{name: 'David', age: 26, favorite_number: [ 6, 7, 9 ] }记录 
匹配db.users.find({favorite_number: {$size: 3}}); 
不匹配db.users.find({favorite_number: {$size: 2}});

$exists判断字段是否存在 
查询所有存在name字段的记录 
db.users.find({name: {$exists: true}}); 
查询所有不存在phone字段的记录 
db.users.find({phone: {$exists: false}});

$type判断字段类型 
查询所有name字段是字符类型的 
db.users.find({name: {$type: 2}}); 
查询所有age字段是整型的 
db.users.find({age: {$type: 16}});

对于字符字段，可以使用正则表达式 
查询以字母b或者B带头的所有记录 
db.users.find({name: /^b.*/i});

$elemMatch(1.3.1及以上版本) 
为数组的字段中匹配其中某个元素

Javascript查询和$where查询 
查询 age > 18 的记录，以下查询都一样 
db.users.find({age: {$gt: 18}}); 
db.users.find({$where: "this.age > 18"}); 
db.users.find("this.age > 18"); 
f = function() {return this.age > 18} db.users.find(f);

排序sort() 
以年龄升序asc 
db.users.find().sort({age: 1}); 
以年龄降序desc 
db.users.find().sort({age: -1});

限制返回记录数量limit() 
返回5条记录 
db.users.find().limit(5); 
返回3条记录并打印信息 
db.users.find().limit(3).forEach(function(user) {print('my age is ' + user.age)}); 
结果 
my age is 18 
my age is 19 
my age is 20

限制返回记录的开始点skip() 
从第3条记录开始，返回5条记录(limit 3, 5) 
db.users.find().skip(3).limit(5);

查询记录条数count() 
db.users.find().count(); 
db.users.find({age:18}).count(); 
以下返回的不是5，而是user表中所有的记录数量 
db.users.find().skip(10).limit(5).count(); 
如果要返回限制之后的记录数量，要使用count(true)或者count(非0) 
db.users.find().skip(10).limit(5).count(true);

分组group() 
假设test表只有以下一条数据 
{ domain: "www.mongodb.org" 
, invoked_at: {d:"2009-11-03", t:"17:14:05"} 
, response_time: 0.05 
, http_action: "GET /display/DOCS/Aggregation" 
} 
使用group统计test表11月份的数据count:count(*)、total_time:sum(response_time)、avg_time:total_time/count; 
db.test.group( 
{ cond: {"invoked_at.d": {$gt: "2009-11", $lt: "2009-12"}} 
, key: {http_action: true} 
, initial: {count: 0, total_time:0} 
, reduce: function(doc, out){ out.count++; out.total_time+=doc.response_time } 
, finalize: function(out){ out.avg_time = out.total_time / out.count } 
} );

[ 
{ 
"http_action" : "GET /display/DOCS/Aggregation", 
"count" : 1, 
"total_time" : 0.05, 
"avg_time" : 0.05 
} 
]

## 日常维护管理:
1. #查看collection数据的大小

  db.deliver_status.dataSize()
２#查看colleciont状态

  db.deliver_status.stats()

3. #查询所有索引的大小

  db.deliver_status.totalIndexSize()

## mongodb服务维护需知:

1,mongod 参数说明
--dbpath            #指定db文件存放的目录
--port              #指定mongod服务使用的端口
--fork              #设置mongo服务为后台运行
--logpath           #指定log文件的目录和文件名
--logappend         #设置每次log添加在文件最后
--rest              #关闭rest api功能
--nohttpinterface   #关闭web管理功能
--auth              #指定mongo使用身份验证机制
--bindip            #用逗号分隔ip地址，用来指定
--f                 #将所有前面介绍的参数都可以存放到一个配置文件中，然后用这个参数调用配置文件来启动
2,mongodb 关闭方法:
a. db.shutdownServer()  #推荐优先使用
b. ctrl + c             #在不使用 --fork参数的时候可以使用，可能会造成数据文件损坏
c. kill / kill -2       #在无法使用 a和b的情况下使用，可能会造成数据文件损坏
d. kill -9              #不在万不得已的情况下，不要使用这个方法

3. 查看MongoDB状态
a.db.runCommand({"serverStatus":1})
b.MONGO_HOME/bin/mongostat

4. 添加用户，切换用户 使 --auth参数起效
db.addUser("root","123")
db.addUser("read_only","123",true);  #第3个参数表示设置readonly的状态

db.auth("read_only","123")

5. 数据库备份
有4种方法备份数据库
a. 关闭mongod服务后，复制--dbpath参数指定的数据文件。优点速度快，缺点需要停止mongo服务。
b. 使用mongodump 导出数据，并用mongorestore 导入数据。优点不需要停止mongo服务，缺点在mongodump操作时用户插入的数据可能无法备份出来。
c. fsync and lock锁定数据库的让用户只能使用read功能，再使用方法b导出并导入数据。优点不需要停止mongo服务，缺点在数据库lock期间用户无法执行insert操作。
d. 使用slaveDB并且 使用方法c锁定slaveDB，再使用方法b导出并导入数据。优点不需要停止mongo服务，不会影响用户insert操作（推荐使用此方法）。

6. 修复数据库
当数据库文件遭到损坏的时候有3种方法修复数据文件
a. MONGO_HOME/bin/mongod --repair
b. use test
db.repairDatabase()
c. db.runCommand({"repairDatabase":1});

7.MongoDB会以令人震惊的方式丢失数据
这里　http://coolshell.cn/articles/5826.html　有详解,值得关注一下.

## mongodb分布式集群操作

查看集群分片信息
db.printShardingStatus()

## 其他维护
指定数据存放位置
```
bin/mongod -dbpath /data/db
```
