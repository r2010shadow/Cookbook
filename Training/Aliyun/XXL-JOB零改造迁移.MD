`xxl-job`

Serverless 应用引擎 SAE（Job功能公测阶段，目前免费）。
Event Bridge（目前免费）。

- 创建并执行demoJobHandler
```
登录SAE管理控制台（https://sae.console.aliyun.com/）
自定义任务模板名称，例如demoJobHandler
专有网络配置选择自动配置
技术栈语言：选择Java。
任务部署方式：选择JAR包部署。
任务运行环境：选择标准Java应用运行环境。
Java环境：选择Open JDK 8。
文件上传方式：选择JAR包地址。
JAR包地址：输入https://sae-demo-cn-shenzhen.oss-cn-shenzhen.aliyuncs.com/xxl-job-executor-sample-springboot-2.3.0.jar。该jar包为中https://github.com/xuxueli/xxl-job的xxl-job-executor-sample-springboot，用户也可自行打包上传。
版本：默认配置即可，无需改动。
时区设置：默认UTC+8，无需改动。
环境变量设置：添加两个变量，第一个变量名称为JOB_TYPE，变量值/变量引用为xxljob-2.3.0，第二个量名称为EXECUTOR_NAME，变量值/变量引用为demoJobHandler。
在任务设置页面，Cron表达式输入为0 */1 * * ?，即每小时执行一次

```

任务基本信息

| 任务模板名: demoJobHandler                         | 命名空间: cn-shenzhen                                        |
| -------------------------------------------------- | ------------------------------------------------------------ |
| 任务模板id: 35c5a431-9eda-43f3-91ce-549a4a...      | VPC: sae.auto.create.vpc.c2547...                            |
| vSwitch: --多vSwitch部署                           | 安全组: --切换安全组                                         |
| 实例规格: 1Core, 2GiB, 系统盘磁盘空间20GiB变更规格 | 程序包名: xxl-job-executor-sample-springboot-2.3.0.jar:1659240441592 |
| 并发实例数: 1                                      | 任务模板描述: --编辑                                         |


```
待任务变更完成之后，在任务模板详情页面，单击手动执行任务
单击任务id
查看日志
```
-  创建并执行shardingJobHandler

```
在任务模板列表页面，找到您上一步骤中创建的任务，单击右侧操作列下的复制。
在任务基本信息页面，任务模板名称修改为shardingJobHandler，专有网络配置选择自动配置，单击下一步：部署配置。
在部署配置页面，参考如下说明进行配置，然后单击下一步：任务设置。
参数说明：

文件上传方式：选择引用其他任务模板JAR包。
应用任务模板：选择demoJobHandler。这样可以使多个定时任务引用同一个程序包进行部署和更新。
环境变量设置：将环境变量中的变量名称为EXECUTOR_NAME的变量值/变量引用改为shardingJobHandler。
在任务设置页面，因为shardingJobHandler为一个分片任务，所以将并发实例数调整为3，并在任务高级设置区域中开启启用任务分片。

```

任务基本信息

| 任务模板名: shardingJobHandler                               | 命名空间: cn-shenzhen                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 任务模板id: a6a2e313-3a63-407b-a91b-8544ff...                | VPC: sae.auto.create.vpc.c2547...                            |
| vSwitch: sae.auto.create.vswitch.v...（可用IP数为252 ）多vSwitch部署 | 安全组: [edas.serverless.donot.delete.vpc-wz93ckl94sgrd3kvbneqs](https://ecs.console.aliyun.com/#/securityGroupDetail/region/cn-shenzhen/groupId/sg-wz94u35a3201eise1s31/detail/intranetIngress)切换安全组 |
| 实例规格: 1Core, 2GiB, 系统盘磁盘空间20GiB变更规格           | 程序包名: xxl-job-executor-sample-springboot-2.3.0.jar:1659240441592 |
| 并发实例数: 3                                                | 任务模板描述: --编辑                                         |




```
单击任务id
将XXL-JOB迁移至SAE Job，详情请参考https://help.aliyun.com/document_detail/432503.html, 借助Serverless job可以轻松实现降本提效
```


| ...-zj8vg | 可用区D sae.auto.create.vswitch.vpc-wz93ckl94sgrd3kvbneqs | 192.168.0.173 | Running | .../sae-serverless-user/1603492658911047_shared_repo:35c5a431-9eda-43f3-91ce-549a4a732875_1659240641037 | 1659240441592 | 12秒 | 实时日志Webshell事件 |
| --------- | --------------------------------------------------------- | ------------- | ------- | ------------------------------------------------------------ | ------------- | ---- | -------------------- |
| ...-w7qll | 可用区D sae.auto.create.vswitch.vpc-wz93ckl94sgrd3kvbneqs | 192.168.0.174 | Running | .../sae-serverless-user/1603492658911047_shared_repo:35c5a431-9eda-43f3-91ce-549a4a732875_1659240641037 | 1659240441592 | 11秒 | 实时日志Webshell事件 |
| ...-hx6vs | 可用区D sae.auto.create.vswitch.vpc-wz93ckl94sgrd3kvbneqs | 192.168.0.172 | Running | .../sae-serverless-user/1603492658911047_shared_repo:35c5a431-9eda-43f3-91ce-549a4a732875_1659240641037 | 1659240441592 | 11秒 | 实时日志Webshell事件 |







- 
