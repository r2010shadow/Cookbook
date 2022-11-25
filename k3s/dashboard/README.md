# 部署 Kubernetes 仪表盘

## dashboard/releases
- recommended.yaml
```
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml
```
- 开启远程访问NodPort，修改recommended.yaml
```
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort       # new
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 31001  # new
```
- token永不过期，修改recommended.yaml
```
          args:
            - --auto-generate-certificates
            - --namespace=kubernetes-dashboard
            - --token-ttl=0

```


## admin-user/role
- dashboard.admin-user.yml

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```
- dashboard.admin-user-role.yml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
```
- 部署
sudo k3s kubectl create -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml

## 获得 Bearer Token
```
1.24+
sudo k3s kubectl -n kubernetes-dashboard create token admin-user
1.23-
sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'
```

## 本地访问仪表盘
```
要访问仪表盘，你必须创建一个安全通道到你的 K3s 集群。

sudo k3s kubectl proxy
现在可以通过以下网址访问仪表盘：

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
使用admin-user Bearer Token Sign In
```

## 远程访问
```
https://MYSERVER:31001/
```

## 升级仪表盘
```
sudo k3s kubectl delete ns kubernetes-dashboard
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml
```


## 删除仪表盘和 admin-user 配置
```
sudo k3s kubectl delete ns kubernetes-dashboard
sudo k3s kubectl delete clusterrolebinding kubernetes-dashboard
sudo k3s kubectl delete clusterrole kubernetes-dashboard
```
