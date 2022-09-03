- mysql支持的复制类型：

- - 基于语句的复制：

  - - 在主服务器上执行的SQL语句

    - 在从服务器上执行同样的语句

    - MySQL**默认**采用基于语句的复制

    - - 效率比较高  

    -  一旦发现没法精确复制时

    - - 会自动选着基于行的复制 

- - 基于行的复制：

  - - 把改变的内容复制过去

    - - 而不是把命令在从服务器上执行一遍.

    - 从mysql5.0开始支持

  - 混合类型的复制: 

  - - 默认采用基于语句的复制

    - - 一旦发现基于语句的无法精确的复制时

      - - 就会采用基于行的复制

- master

- - 将改变记录到二进制日志binary log中

  - - 这些记录叫做二进制日志事件binary log events

- slave

- - 将master的binary log events拷贝到它的中继日志relay log

  - slave重做中继日志中的事件

  - - 将改变反映它自己的数据

- 

   

- 主从配置

- - 创建复制账号

  - - master为每个slave一个账号
    - GRANT REPLICATION SLAVE,RELOAD,SUPER ON ** TO backup@'IP' IDENTIFIED BY 'password';
    - 密码存储在文本文件master.info中

  - 拷贝数据

  - - 完全新装忽略此步骤
    - 关停Master服务器
    - 将Master中的数据拷贝到B服务器中
    - 使得Master和slave中的数据同步
    - 并且确保在全部设置操作结束前
    - 禁止在Master和slave服务器中进行写操作
    - 使得两数据库中的数据一定要相同

  - 配置master

  - - 打开二进制日志
    - server-id  =1         为主服务器A的ID值
    - log-bin  =mysql-bin   二进制变更日值
    - SHOW MASTER STATUS\G;
    - show processlist\G;

  - 配置slaver

  - - log_bin      = mysql-bin
    - server_id     = 2
    - relay_log     = mysql-relay-bin      中继日志
    - log_slave_updates = 1
    - read_only     = 1                  防止改变数据

  - 启动slave

  - - CHANGE MASTER TO MASTER_HOST='server1',  \
    - MASTER_USER='repl',  \
    - MASTER_PASSWORD='password',  \
    - Mster_log_file='mysql-bin.000001',  \
    - MASTER_LOG_POS=0;             日志的开始位置
    - SHOW SLAVE STATUS\G   ;



- 克隆一个slave

- - 冷拷贝

  - - 停止M
    - 拷贝M到S

  - 热拷贝

  - - 服务运行中
    - 仅对MYISAM使用mysqlhotcopy

  - 使用mysqldump

  - - 在一个连接中锁表FLUSH TABLES WITH READ LOCK;
    - 在另一个连接转存用mysqldump -all-databases --lock-all-tables > dbdump.db
    - 对表释放锁UNLOCK TABLES;



- 主从复制也带来其他一系列性能瓶颈问题：

- - 写入无法扩展
  - 写入无法缓存
  - 复制延时
  - 锁表率上升
  - 表变大，缓存率下降
