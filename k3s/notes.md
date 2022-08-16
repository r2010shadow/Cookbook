
- Server
```
curl -sfL https://get.k3s.io | sh -   国际

curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -   国内

Token  /var/lib/rancher/k3s/server/node-token  `mynodetoken` 
```


- Client
```
hosts  echo "myserverIP myserver" >> /etc/hosts 

curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -  国际

curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

/usr/local/bin/k3s-agent-uninstall.sh   卸载
```
```
