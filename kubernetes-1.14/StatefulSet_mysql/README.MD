[Statefulset_mysql](https://kubernetes.io/zh-cn/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)

* 资源配置

| kubectl apply -k ./              | 创建此目录下所有         |
| -------------------------------- | ------------------------ |
| kubectl get secrets              |                          |
| kubectl get pvc pods             |                          |
| kubectl get services wordpress   |                          |
| minikube service wordpress --url | http://172.17.0.74:32087 |
| kubectl delete -k ./             |                          |


* 创建 Secret 生成器
```
Secret 是存储诸如密码或密钥之类的敏感数据的对象。 从 1.14 开始，kubectl支持使用 kustomization 文件管理 Kubernetes 对象。 
可以通过kustomization.yaml中的生成器创建一个 Secret。

通过以下命令在kustomization.yaml中添加一个 Secret 生成器。 你需要用你要使用的密码替换YOUR_PASSWORD。
```

```
cat <<EOF >./kustomization.yaml
secretGenerator:
- name: mysql-pass
  literals:
  - password=YOUR_PASSWORD
EOF
```
