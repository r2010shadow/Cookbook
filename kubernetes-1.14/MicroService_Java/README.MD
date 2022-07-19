# 示例工程-JAVA微服务

[配置Java微服务](https://kubernetes.io/zh-cn/docs/tutorials/configuration/configure-java-microservice/)

* 目录

```
.CASE
├── inventory
│   ├── Dockerfile
│   ├── pom.xml
│   └── src
├── kubernetes.yaml
├── pom.xml
└── system
    ├── Dockerfile
    ├── pom.xml
    └── src
```

* 配置项

| system env:        | inventory env:                  |
| ------------------ | ------------------------------- |
| configMapKeyRef    | secretKeyRef                    |
| name: sys-app-name | name: sys-app-credentials       |
| key: name          | key: username <br>key: password |

* STEPS

| mvn package -pl system                                       | .                                               |
| ------------------------------------------------------------ | ----------------------------------------------- |
| mvn package -pl inventory                                    | .                                               |
| kubectl apply -f kubernetes.yaml                             | .                                               |
| kubectl wait --for=condition=ready pod -l app=inventory      | .                                               |
| curl -u bob:bobpwd http://$( minikube ip ):31000/system/properties | .                                               |
| curl http://$( minikube ip ):32000/inventory/systems/system-service | .                                               |
| curl -# -I -u bob:bobpwd -D - http://$( minikube ip ):31000/system/properties \|grep -i ^X-App-Name: | X-App-Name: system<br/>X-App-Name: system       |
| kubectl create configmap sys-app-name --from-literal **name**=my-system |                                                 |
| kubectl create secret generic sys-app-credentials --from-literal username=bob --from-literal **password**=bobpwd |                                                 |
| mvn package I II                                             | java代码修改重构                                |
| kubectl replace --force -f kubernetes.yaml                   | 修改yaml并更新                                  |
| curl -# -I -u bob:bobpwd -D - http://$( minikube ip ):31000/system/properties \| grep -i ^X-App-Name: | X-App-Name: my-system<br/>X-App-Name: my-system |
