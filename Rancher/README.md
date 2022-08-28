# rancher-notes

## 国内使用rancher

[Link](https://docs.rancher.cn/docs/rancher2/best-practices/use-in-china/_index)

1. 使用阿里云镜像仓库的 rancher 镜像启动 rancher

```
docker run -itd -p 80:80 -p 443:443 --restart=unless-stopped --privileged -e CATTLE_AGENT_IMAGE="registry.cn-hangzhou.aliyuncs.com/rancher/rancher-agent:v2.5.2" registry.cn-hangzhou.aliyuncs.com/rancher/rancher:v2.5.2

docker run -itd -p 80:80 -p 443:443 --restart=unless-stopped -e CATTLE_AGENT_IMAGE="registry.cn-hangzhou.aliyuncs.com/rancher/rancher-agent:v2.4.2" registry.cn-hangzhou.aliyuncs.com/rancher/rancher:v2.4.2
```

2. 设置默认镜像仓库

从 UI 导航到`Settings`，然后编辑`system-default-registry`，Value 设置为`registry.cn-hangzhou.aliyuncs.com`





---

[link](https://blog.51cto.com/denwork/2525330?tdsourcetag=s_pctim_aiomsg)

- k3s

curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -

 /usr/local/bin/k3s-uninstall.sh

- helm

shell> wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
shell> tar -xf helm-v3.2.4-linux-amd64.tar.gz
shell> mv linux-amd64/helm /usr/bin/

- k3s.yaml

echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /etc/profile && source /etc/profile

- 添加rancher镜像源

helm repo add rancher-stable http://rancher-mirror.oss-cn-beijing.aliyuncs.com/server-charts/stable

helm repo update

- ns

kubectl create namespace cattle-system

## 使用Let’s Encrypt证书

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml

helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.1

```
NAME: cert-manager
LAST DEPLOYED: Thu Aug 25 09:50:16 2022
NAMESPACE: cert-manager
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
cert-manager v1.5.1 has been deployed successfully!
```

kubectl get pods --namespace cert-manager

```
root@toor:~/rancher-cert# kubectl get pods --namespace cert-manager
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-cainjector-647fd87d5b-2v5sz   1/1     Running   0          3m59s
cert-manager-webhook-6d84589d9-qc4xc       1/1     Running   0          3m59s
cert-manager-6cfdbb4cdf-pg8cm              1/1     Running   0          3m59s
```

## 安装Rancher

helm install rancher rancher-stable/rancher  --namespace cattle-system --set hostname=demo.rancher.com --set replicas=3  --set ingress.tls.source=letsEncrypt  --set rancherImage=registry.cn-hangzhou.aliyuncs.com/rancher/rancher --set letsEncrypt.email=me@example.org

```
NAME: rancher
LAST DEPLOYED: Thu Aug 25 09:55:27 2022
NAMESPACE: cattle-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Rancher Server has been installed.
```

- 安装指定版本

```
helm install rancher rancher-stable/rancher \
  --version v2.5.12 \
  --namespace cattle-system \
  --set hostname=demo.rancher.com\
  --set ingress.tls.source=letsEncrypt \
  --set rancherImage=registry.cn-hangzhou.aliyuncs.com/rancher/rancher \
  --set letsEncrypt.email=me@example.org
```

- 密码

root@toor:~/rancher-cert# kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
njdgxzzq2t7hmvw794czgr7qb4l6zcsk92hwkdh8g7jbjqr49b68zc

- 域名查看

root@toor:~/rancher-cert# helm get values rancher -n cattle-system
USER-SUPPLIED VALUES:
hostname: demo.rancher.com
ingress:
  tls:
    source: letsEncrypt
letsEncrypt:
  email: me@example.org
rancherImage: registry.cn-hangzhou.aliyuncs.com/rancher/rancher
replicas: 3

- 卸载rancher

helm delete rancher -n cattle-system

