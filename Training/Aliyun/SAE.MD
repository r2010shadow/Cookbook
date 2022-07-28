Serverless App Engine

`Serverless Job 定时获取新闻热搜`
- Serverless应用引擎SAE（Job功能公测阶段，目前免费）。
- Event Bridge（目前免费）。
- NAT网关。
- 弹性公网IP。

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


