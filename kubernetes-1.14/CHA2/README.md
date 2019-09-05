

## CRI容器运行时支持 -- Docker

### 2.2.1
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum install docker-ce-18.09.3 -y

cat >  /etc/docker/daemon.json  << EOF
{
  "registry-mirrors": ["http://registry.docker-cn.com"]
}
EOF
systemctl enable docker && systemctl start docker



yum install kubelet-1.14.1  kubectl-1.14.1 kubeadm-1.14.1

### 2.2.2
kubeadm config print init-defaults > init.default.yaml

### 2.2.3
kubeadm config images pull --config=init-config.yaml

### 2.2.4
kubeadm init --config=init-config.yaml
