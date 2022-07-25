`Helm就是kubernetes的应用程序包管理器`
* 类似于Linux系统上的 yum 或 apt-get 等，可用于实现帮助用户查找，分享及使用kubernetes应用程序，目前的版本由CNCF（Microsoft，Google，Bitnami 和 Helm 社区） 维护。
* yaml文件为硬编码，无变量可欠灵活

* Helm组件及相关术语
```
Helm将kubernetes资源（Deployment，service或configmap等）打包到一个charts中，
制作并测试完成的各个charts 将保存到charts仓库进行存储和分发。

  Helm Client (helm) --> Chart Repository
        |
        |
|-------- K8s Cluster-----------------------------|        
|  Helm Server (Tiller) --> Kubernetes API Server |   
```


`优势`
* 管理复杂应用： charts能够描述哪怕是最复杂的程序结构，其提供了可重复使用的应用安装的定义。
* 易于升级： 使用就地升级和自定义钩子来解决更新的难题。
* 简单分享： charts易于通过公共或私用服务完成版本化，分享及主机构建。
* 回滚：可使用 “helm rollback” 命令轻松实现快速回滚。
---
`helm命令`
* helm repo list 
- - 查看helm仓库
```
Helm安装时已经默认配置好了两个仓库：stable和local。
stable是官方仓库，local是用户存放自己开发的chart的本地仓库。
[root@master helm]# helm repo list
NAME  	URL                                             
stable	https://kubernetes-charts.storage.googleapis.com
stable	https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
local 	http://127.0.0.1:8879/charts 
```
* helm repo add 
- - 添加阿里的源
```
[root@master helm]# helm repo add stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
"stable" has been added to your repositories
```
* helm  repo update
- - 更新一下仓库
```
[root@master helm]# helm  repo update
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "stable" chart repository
Update Complete.repo# 实用命令 dsarr
ddh reelm 
```
* helm search 
- - 查看仓库中具有的chart
```
[root@master helm]# helm search mysql
NAME                         	CHART VERSION	APP VERSION	DESCRIPTION                                                 
stable/mysql                 	0.3.5        	           	Fast, reliable, scalable, and easy to use open-source rel...
stable/percona               	0.3.0        	           	free, fully compatible, enhanced, open source drop-in rep...
stable/percona-xtradb-cluster	0.0.2        	5.7.19     	free, fully compatible, enhanced, open source drop-in rep...
stable/gcloud-sqlproxy       	0.2.3        	           	Google Cloud SQL Proxy                                      
stable/mariadb               	2.1.6        	10.1.31    	Fast, reliable, scalable, and easy to use open-source rel...
```
* helm install 
- - 命令进行安装
```
[root@master helm]# helm install stable/mysql

NAME:   mean-spaniel
LAST DEPLOYED: Sat Feb 15 14:43:39 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/PersistentVolumeClaim
NAME                STATUS   VOLUME  CAPACITY  ACCESS MODES  STORAGECLASS  AGE
mean-spaniel-mysql  Pending  0s

==> v1/Pod(related)
NAME                                 READY  STATUS   RESTARTS  AGE
mean-spaniel-mysql-5868455f75-n8lb6  0/1    Pending  0         0s

==> v1/Secret
NAME                TYPE    DATA  AGE
mean-spaniel-mysql  Opaque  2     0s

==> v1/Service
NAME                TYPE       CLUSTER-IP    EXTERNAL-IP  PORT(S)   AGE
mean-spaniel-mysql  ClusterIP  10.102.92.19  <none>       3306/TCP  0s

==> v1beta1/Deployment
NAME                READY  UP-TO-DATE  AVAILABLE  AGE
mean-spaniel-mysql  0/1    1           0          0s


NOTES:
MySQL can be accessed via port 3306 on the following DNS name from within your cluster:
mean-spaniel-mysql.default.svc.cluster.local

To get your root password run:

    MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mean-spaniel-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

To connect to your database:

1. Run an Ubuntu pod that you can use as a client:

    kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il

2. Install the mysql client:

    $ apt-get update && apt-get install mysql-client -y

3. Connect using the mysql cli, then provide your password:
    $ mysql -h mean-spaniel-mysql -p

To connect to your database directly from outside the K8s cluster:
    MYSQL_HOST=127.0.0.1
    MYSQL_PORT=3306

    # Execute the following commands to route the connection:
    export POD_NAME=$(kubectl get pods --namespace default -l "app=mean-spaniel-mysql" -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 3306:3306

    mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}
```
```
输出信息分为三个部分：
1）chart本次部署的描述信息：
NAME 是 release的名字，如果不使用-n 参数指定，则随机生成一个
NAMESPACE 是 release 部署的namespace，默认是default，也可以通过–namespace 指定。
STATUS 为DEPLOYED，表示已经将chart部署到集群。

2）当前 release包含的资源（RESOURCES）：
Service，Deployment，Secret和PersistentVolumeClaim，其名字都是
mean-spaniel-mysql，命名的格式为“ReleaseName-ChartName”。

3）NOTES 部分显示的是 release的使用方式。比如如何访问Service，如何获取数据库密码，以及如何连接数据库等。
```
* helm list 
- - 可以查看已经部署的实例
```
[root@master helm]# helm list 
NAME        	REVISION	UPDATED                 	STATUS  	CHART      	APP VERSION	NAMESPACE
mean-spaniel	1       	Sat Feb 15 14:43:39 2020	DEPLOYED
```
* helm status 
- - 命令查看实例的状态
```
[root@master helm]# helm status mean-spaniel

LAST DEPLOYED: Sat Feb 15 14:43:39 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/PersistentVolumeClaim
NAME                STATUS   VOLUME  CAPACITY  ACCESS MODES  STORAGECLASS  AGE
mean-spaniel-mysql  Pending  26m

==> v1/Pod(related)
NAME                                 READY  STATUS   RESTARTS  AGE
mean-spaniel-mysql-5868455f75-n8lb6  0/1    Pending  0         26m

==> v1/Secret
NAME                TYPE    DATA  AGE
mean-spaniel-mysql  Opaque  2     26m

==> v1/Service
NAME                TYPE       CLUSTER-IP    EXTERNAL-IP  PORT(S)   AGE
mean-spaniel-mysql  ClusterIP  10.102.92.19  <none>       3306/TCP  26m

==> v1beta1/Deployment
NAME                READY  UP-TO-DATE  AVAILABLE  AGE
mean-spaniel-mysql  0/1    1           0          26m
```
* helm delete 
- - 命令可以删除部署的实例
- - 加上 -purge删除缓存，才能够彻底的删除
```
[root@master helm]# helm delete mean-spaniel --purge
release "mean-spaniel" deleted
```
---
`chart 目录结构`
* Charts是Helm使用的kubernetes程序包打包格式，一个charts就是一个描述一组kubernetes资源的文件的集合。

* chart 将这些文件放置在预定义的目录结构中，通常整个chart被打包成tar包，而且标注上版本信息，便于Helm部署。

* 可以在安装目录下，~/.helm/cache/archive 中找到 chart 的 tar 包。
```
[root@master helm]# ls ~/.helm/cache/archive/
mysql-0.3.5.tgz
mysql chart 目录结构如下

[root@master helm]# tree -C mysql/
mysql/
├── Chart.yaml
├── README.md
├── templates
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   ├── pvc.yaml
│   ├── secrets.yaml
│   └── svc.yaml
└── values.yaml
```
- - 包含如下内容：
```
（1）chart.yaml：YAML文件，描述chart的概要信息，其中，name和version是必填项，其他都是可选的。

（2）README.md：Markdown 格式的README 文件，也就是chart的使用文档，此文件可选。

（3）values.yaml ：chart支持在安装的时根据参数进行定制化配置，而values.yaml 则提供了这些配置参数的默认值。

（4）templates 目录 ：各类kubernetes资源的配置模板都放置在这里。Helm会将values.yaml 中的参数值注入到模板中生成标准的YAML配置文件。模板是chart最重要的部分，也是helm最强大地方。模板增加了应用部署的灵活性，能够适用不同的环境。
```
