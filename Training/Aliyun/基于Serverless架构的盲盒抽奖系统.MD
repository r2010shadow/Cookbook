- 基于Serverless架构的盲盒抽奖系统

```
进入到函数计算控制台：https://fcnext.console.aliyun.com/overview
通过模板创建应用- 游戏- 盲盒
选择立即创建，然后选择直接部署：
此时需要点击前往授权进行授权

```

- 部署详情
- - 部署成功，点击访问域名：http://api.blindbox-service.1603492658911047.cn-shanghai.fc.devsapp.net
- - 前置环境
```
2022-08-02 06:05:02 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke Start RequestId: 1659420302050000
2022-08-02 06:05:02 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Begin to setup Serverless Devs...
2022-08-02 06:05:03 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Serverless Devs already installed, version["@serverless-devs/s: 2.1.4, s-home: /kaniko/.s, linux-x64, node-v14.19.2\n"]

Alias:           1659420299412000
  AccessKeyID:     STS***********************kzn
  AccessKeySecret: GSb**************************************Kis
  SecurityToken:   CAI**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************Jg=
  AccountID:       160**********047

- Configuration successful
2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Serverless Devs access is successfully configured
✔ Configuration successful
2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Success to setup Serverless Devs!

2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke End RequestId: 1659420302050000
```
- - 资源同步
```
2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke Start RequestId: 1659420305828000
2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Sync code version: {}
2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Sync code start: {}
2022-08-02 06:05:05 INFO 70982608-e788-4bb1-8534-4295a709eda9 - s init blindbox-game --parameters {} --appName blindbox-game-7qck --access default -d /kaniko/tmp/1603492658911047/blindbox-game-7qck/1659420299412000
2022-08-02 06:05:07 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Sync code succeed！
2022-08-02 06:05:07 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke End RequestId: 1659420305828000
```
- - 资源检查
```
2022-08-02 06:05:07 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke Start RequestId: 1659420307181000
2022-08-02 06:05:07 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Begin to generate the plan...
2022-08-02 06:05:07 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Execute command: s  plan, args: ["--access 1659420299412000"]


- Downloading: [/devsapp/fc/zipball/0.1.54]
✔ devsapp_fc.zip file decompression completed
- Downloading: [/devsapp/core/zipball/0.1.44]
✔ core@0.1.44.zip file decompression completed
- Downloading: [/devsapp/fc-plan/zipball/0.0.33]
✔ devsapp_fc-plan.zip file decompression completed
- Downloading: [/devsapp/fc-core/zipball/0.0.20]
✔ devsapp_fc-core.zip file decompression completed


region: cn-shanghai
service:
[J2022-08-02 06:05:12 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Success to generate the plan!
  name:           blindbox-service
  description:    盲盒应用的服务
  internetAccess: true
function:
2022-08-02 06:05:12 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke End RequestId: 1659420307181000
name:                api
  description:         盲盒应用的函数
  runtime:             custom
  codeUri:             ./code
  handler:             index.handler
  memorySize:          256
  timeout:             10
  gpuMemorySize:       8192
  caPort:              9000
  instanceConcurrency: 1
  instanceType:        e1
triggers:
name:   httpTrigger
  type:   http
  config: 
    authType: anonymous
    methods: 
      - GET
      - POST
      - PUT
      - DELETE
customDomains:
domainName:   auto
  protocol:     HTTP
  routeConfigs: 
    - 
      path: /*



End of method: plan
```
- - 执行部署
```
2022-08-02 06:05:12 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke Start RequestId: 1659420312472000
2022-08-02 06:05:12 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Begin to use Serverless Devs to deploy ...
2022-08-02 06:05:12 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Execute command: s  deploy, args: ["--access 1659420299412000","--use-local","--assume-yes","--skip-push"]


[2022-08-02 06:05:13] [INFO] [S-CORE] - Start the pre-action
[2022-08-02 06:05:13] [INFO] [S-CORE] - Action: npm i
npm WARN deprecated superagent@6.1.0: Please upgrade to v7.0.2+ of superagent.  We have fixed numerous issues with streams, form-data, attach(), filesystem errors not bubbling up (ENOENT on attach()), and all tests are now passing.  See the releases tab for more information at <https://github.com/visionmedia/superagent/releases>.
npm WARN deprecated formidable@1.2.6: Please upgrade to latest, formidable@v2 or formidable@v3! Check these notes: https://bit.ly/2ZEqIau
npm WARN deprecated querystring@0.2.0: The querystring API is considered Legacy. new code should use the URLSearchParams API instead.

> nodemon@2.0.19 postinstall /kaniko/tmp/1603492658911047/blindbox-game-7qck/1659420299412000/code/node_modules/nodemon
> node bin/postinstall || exit 0

Love nodemon? You can now support the project via the open collective:
 > https://opencollective.com/nodemon/donate

npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@~2.3.2 (node_modules/chokidar/node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@2.3.2: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
npm added 383 packages from 445 contributors and audited 385 packages in 12.989s
WARN index@1.0.0 No description
npm WARN index@1.0.0 No repository field.


33 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

[2022-08-02 06:05:27] [INFO] [S-CORE] - End the pre-action
- Downloading: [/devsapp/fc-deploy/zipball/0.0.84]
✔ devsapp_fc-deploy.zip file decompression completed
- Checking Service blindbox-service exists
- Checking Service blindbox-service exists
- Downloading: [/devsapp/fc-info/zipball/0.0.27]
✔ devsapp_fc-info.zip file decompression completed
- Checking Function api exists
- Checking Function api exists
- Checking Triggers
- Checking Triggers
✔ Checking Service, Function, Triggers (8.29s)
- Creating Service blindbox-service...
- Creating Function blindbox-service/api...
- Creating Trigger...
✔ Creating Service, Function, Triggers (8.23s)
- Generated auto custom domain...
- Downloading: [/devsapp/domain/zipball/0.0.30]
✔ devsapp_domain.zip file decompression completed
- Generated auto custom domain...
- Downloading: [/devsapp/fc-default/zipball/0.0.25]
✔ devsapp_fc-default.zip file decompression completed
- Get token....
- Deploy helper function...
- Get domain....
✔ Generated custom domain (2.31s)
- Creating custom domain...
- Creating custom domain...
✔ Creating custom domain (6.84s)

Tips for next step
======================
* Display information of the deployed resource: s info
* Display metrics: s metrics
* Display logs: s logs
* Invoke remote function: s invoke
* Remove Service: s remove service
* Remove Function: s remove function
* Remove Trigger: s remove trigger
* Remove CustomDomain: s remove domain



blindbox: 
  region:   cn-shanghai
  service: 
    name: blindbox-service
  function: 
    name:       api
    runtime:    custom
    handler:    index.handler
    memorySize: 256
    timeout:    10
  url: 
    system_url:    https://api-blindbo-service-uvlpxlpwxd.cn-shanghai.fcapp.run
    custom_domain: 
      - 
        domain: http://api.blindbox-service.1603492658911047.cn-shanghai.fc.devsapp.net
  triggers: 
    - 
      type: http
      name: httpTrigger

2022-08-02 06:05:55 INFO 70982608-e788-4bb1-8534-4295a709eda9 - Success to deploy!
2022-08-02 06:05:55 INFO 70982608-e788-4bb1-8534-4295a709eda9 - FC Invoke End RequestId: 1659420312472000
```
