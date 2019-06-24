![Zentao](http://www.zentao.net/file.php?f=201604/f_a5a3577d688b18e4dffde47e422704f9.png&t=png&o=&s=&v=1517389139)

[link](http://zentao.kjtjia.com/zentao/doc-view-9.html "开源禅道文档")

[    文档更新日期：20171227-v1.2    ]

[    文档更新摘要：配置文件   ]

[开源禅道文档]



[目录]

    [原理简介]

        使用docker部署并管理禅道环境

        部署目录 /home/app/zento

       数据持久化目录 /home/app/zento/mysql/

        模板数据库mysql.tar.gz   

 

    [依赖环境]

        [硬件]

        [操作系统版本]

            centos7.3

        [软件版本]

            docker1.12

            zentao9.5

    [部署简介]

        docker

            部署docker

            编写Dockerfile

            构建镜像

            启动维护

        zentao

            使用zentao







docker

    部署docker

        yum install -y docker,git,wget

        systemctl start docker

        

    编写Dockerfile

         参后



    构建镜像

        docker build -t kjt/zento .



    执行维护   

        部署模板数据库

            tar xvf mysql.tar.gz

        启动容器 

            docker run -d --name zentao -p 80:80 -v /home/app/zento/mysql/:/opt/zbox/data/mysql/ kjt/zento 

        交互容器

            docker exec -it zentao bash



配置文件

    数据库

        /app/zentao/config/my.php





zentao

    使用zentao

        zentao访问地址

        文档库使用说明









[引用资料]

    [禅道使用手册]

    [禅道创始人王春生]

