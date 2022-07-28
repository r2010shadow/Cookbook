Serverless App Engine

`Serverless Job 定时获取新闻热搜`
- Serverless应用引擎SAE（Job功能公测阶段，目前免费）。
- Event Bridge（目前免费）。
- NAT网关。
- 弹性公网IP。

* 创建SAE 任务
`登录SAE管理控制台（https://sae.console.aliyun.com/）`
```
任务模板名称输入为sae-hot-news
参数说明：

技术栈语言：选择Java。
任务部署方式：选择JAR包部署。
任务运行环境：选择标准Java应用运行环境。
Java环境：选择Open JDK 8。
文件上传方式：选择JAR包地址。
JAR包地址：输入https://sae-demo-cn-shenzhen.oss-cn-shenzhen.aliyuncs.com/resou-1.0-SNAPSHOT-jar-with-dependencies.jar。
版本：默认配置即可，无需改动。
时区设置：默认UTC+8，无需改动。
在任务设置页面，Cron表达式输入为0 */1 * * ?，即每小时执行一次
```
* 开通公网访问能力
`登录专有网络控制台（https://vpc.console.aliyun.com/nat/cn-shenzhen/nats）`
```
创建NAT网关
访问模式选择为VPC全通模式（SNAT），弹性公网IP选择为新购弹性公网ip，带宽峰值调整为1Mbps


```

|    资源操作    |                            资源ID                            | 资源状态 |
| :------------: | :----------------------------------------------------------: | :------: |
| 创建弹性公网IP | [eip-wz9p86d7p68cjn75jag99](https://vpc.console.aliyun.com/eip/cn-shenzhen/eips/eip-wz9p86d7p68cjn75jag99) | 创建成功 |
|  创建NAT网关   | [ngw-wz94stq8l79fcvy4esuks](https://vpc.console.aliyun.com/nat/cn-shenzhen/nats/ngw-wz94stq8l79fcvy4esuks) | 创建成功 |
| 绑定弹性公网IP | [eip-wz9p86d7p68cjn75jag99](https://vpc.console.aliyun.com/eip/cn-shenzhen/eips/eip-wz9p86d7p68cjn75jag99) | 绑定成功 |
|  创建SNAT条目  | [snat-wz9gg2n0pw40z2thi12r1](https://vpc.console.aliyun.com/nat/cn-shenzhen/nats/ngw-wz94stq8l79fcvy4esuks/snats) | 创建成功 |


---
* 任务信息

| 任务模板名: sae-hot-news                                     | 命名空间: cn-shenzhen                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 任务模板id: c2547e9d-992f-4d6a-bef6-ea3b8d...                | VPC: sae.auto.create.vpc.c2547...                            |
| vSwitch: sae.auto.create.vswitch.v...（可用IP数为250 ）多vSwitch部署 | 安全组: [edas.serverless.donot.delete.vpc-wz93ckl94sgrd3kvbneqs](https://ecs.console.aliyun.com/#/securityGroupDetail/region/cn-shenzhen/groupId/sg-wz94u35a3201eise1s31/detail/intranetIngress)切换安全组 |
| 实例规格: 1Core, 2GiB, 系统盘磁盘空间20GiB变更规格           | 程序包名: resou-1.0-SNAPSHOT-jar-with-dependencies.jar:1659000569729 |
| 并发实例数: 1                                                | 任务模板描述: --编辑                                         |


* 任务记录

| 任务id                                      | 执行状态 | 正在运行/成功/失败实例数 | 创建时间            | 完成时间            | 操作 |
| :------------------------------------------ | :------- | :----------------------- | :------------------ | :------------------ | :--- |
| manual-5da40714-d7be-4c8d-be27-f7e64ac6fa32 | 未执行   | 0 / 0 / 0                | 2022-07-28 17:47:57 | -                   | 删除 |
| manual-4fe180f4-eb93-4bd1-aae8-617d0d85c9d7 | 执行成功 | 0 / 1 / 0                | 2022-07-28 17:46:51 | 2022-07-28 17:47:21 | 删除 |
| manual-b7ab4560-8a40-4599-8372-00277492c6cf | 执行成功 | 0 / 1 / 0                | 2022-07-28 17:44:03 | 2022-07-28 17:44:37 | 删除 |



* 执行SAE任务
```
任务模版列表/任务模版详情 手动执行任务
任务id - 》 实时日志 

2022-07-28 17时热搜TOP10
2002592   张杰谢娜与房产经纪名誉权纠纷案将开庭
1665975   工信部部长肖亚庆被查
1634193   杜富国钱七虎聂海胜荣获八一勋章
1634123   赵英俊       
1631913   女生因吃不到火锅和男友闹分手
1485092   范丞丞好会亲    
856276    官方回应22岁女孩加班猝死
836943    今年国庆休7天上7天
557137    男子节食1个月瘦10公斤得脂肪肝
554198    房地产专家呼吁给年轻人降首付
```

* 事件信息

| 事件等级 | 事件原因                                                     | 来源类型         | 来源名 | 首次发生时间                                      | 最近发生时间        |                     |
| :------- | :----------------------------------------------------------- | :--------------- | :----- | :------------------------------------------------ | :------------------ | ------------------- |
|          | Normal                                                       | Scheduled        | Pod    | manual-4fe180f4-eb93-4bd1-aae8-617d0d85c9d7-49j8g | 2022-07-28 17:46:51 | 2022-07-28 17:46:51 |
|          | Begin to bind eni                                            |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Scheduled        | Pod    | manual-4fe180f4-eb93-4bd1-aae8-617d0d85c9d7-49j8g | 2022-07-28 17:46:51 | 2022-07-28 17:46:51 |
|          | Successfully assigned sl-1603492658911047-cn-shenzhen/manual-4fe180f4-eb93-4bd1-aae8-617d0d85c9d7-49j8g to vk-default-asg-1901326133080633704, elapsedTime: 48.48328ms |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Completed        | Job    | manual-b7ab4560-8a40-4599-8372-00277492c6cf       | 2022-07-28 17:44:43 | 2022-07-28 17:44:43 |
|          | Job completed                                                |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Created          | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:33 | 2022-07-28 17:44:33 |
|          | Created container main                                       |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Started          | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:33 | 2022-07-28 17:44:33 |
|          | Started container main                                       |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Pulled           | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:33 | 2022-07-28 17:44:33 |
|          | Successfully pulled image "cn-shenzhen.online-vpc.cr.sae.aliyuncs.com/sae-serverless-user/1603492658911047_shared_repo:c2547e9d-992f-4d6a-bef6-ea3b8db71bbf_1659000659615" in 12.209979947s |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Pulling          | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:23 | 2022-07-28 17:44:23 |
|          | Pulling image "cn-shenzhen.online-vpc.cr.sae.aliyuncs.com/sae-serverless-user/1603492658911047_shared_repo:c2547e9d-992f-4d6a-bef6-ea3b8db71bbf_1659000659615" |                  |        |                                                   |                     |                     |
|          | Normal                                                       | SuccessfulCreate | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:06 | 2022-07-28 17:44:06 |
|          | Created pod: manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22, eciId: eci-wz98v00ypnoj8n3mnikt, elapsedTime 1.577s |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Scheduled        | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:04 | 2022-07-28 17:44:04 |
|          | Begin to bind eni                                            |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Scheduled        | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:04 | 2022-07-28 17:44:04 |
|          | Successfully bind.                                           |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Scheduled        | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:04 | 2022-07-28 17:44:04 |
|          | Begin to select vswitch and provider                         |                  |        |                                                   |                     |                     |
|          | Normal                                                       | SuccessfulCreate | Job    | manual-b7ab4560-8a40-4599-8372-00277492c6cf       | 2022-07-28 17:44:04 | 2022-07-28 17:44:04 |
|          | Created pod: manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 |                  |        |                                                   |                     |                     |
|          | Normal                                                       | Scheduled        | Pod    | manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 | 2022-07-28 17:44:04 | 2022-07-28 17:44:04 |
|          | Successfully assigned sl-1603492658911047-cn-shenzhen/manual-b7ab4560-8a40-4599-8372-00277492c6cf-pbh22 to vk-default-asg-1901326133080633704, elapsedTime: 478.094282ms |                  |        |                                                   |                     |                     |



