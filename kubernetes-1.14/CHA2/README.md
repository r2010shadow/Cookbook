## Kubernetes 1.14 Chapter 2


### 2.2.1
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

yum install docker-ce-18.09.3 -y

systemctl enable docker && systemctl start docker

#### Container runtimes https://kubernetes.io/docs/setup/production-environment/container-runtimes/

yum install yum-utils device-mapper-persistent-data lvm2

mkdir -p /etc/systemd/system/docker.service.d

cat >  /etc/docker/daemon.json  << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "registry-mirrors": ["http://registry.docker-cn.com"]
}
EOF

systemctl restart docker

yum install kubelet-1.14.1  kubectl-1.14.1 kubeadm-1.14.1

### 2.2.2
kubeadm config print init-defaults > init.default.yaml

### 2.2.3
kubeadm config images pull --config=init-config.yaml

### 2.2.4
kubeadm init --config=init-config.yaml

#### more info @ init-config
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get -n kube-system configmap

NAME                                 DATA   AGE
coredns                              1      65m
extension-apiserver-authentication   6      65m
kube-proxy                           2      65m
kubeadm-config                       2      65m
kubelet-config-1.14                  1      65m


### 2.2.5
yum install kubelet-1.14.1  kubeadm-1.14.1  # other nodes join steps.
