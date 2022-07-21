
* 假设：
`原先应用Dockerfile的CMD指令为CMD [“Python”, “app.py”]，应用打印日志的路径为/var/log/app.log。`

* 实现：
```
第一步：在原先Dockerfile所在目录下，创建一个run.sh文件，文件内容为：

`#!/bin/bash

tail -F /var/log/app.log &

exec python app.py

第二步：修改Dockerfile，删除原先的CMD，替换为三个指令。

指令一：ADD run.sh /；

指令二：RUN chmod +x run.sh;

指令三：CMD [“./run.sh”]


原理剖析：

run.sh中启动了一个后台进程，使用tail命令强制将/var/log/app.log的内容传输至标准输出，

随后使用exec命令将python app.py作为容器的主进程运行。
```
