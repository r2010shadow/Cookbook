## Kubernetes 1.14 Chapter 2


### 2.2.1
	wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

	yum install -y docker-ce-18.09.3

	systemctl enable docker && systemctl start docker

#### TIPS: Container runtimes 
#### Webiste: https://kubernetes.io/docs/setup/production-environment/container-runtimes/

	yum install -y yum-utils device-mapper-persistent-data lvm2

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

	yum install -y kubelet-1.14.1  kubectl-1.14.1 kubeadm-1.14.1

### 2.2.2
	kubeadm config print init-defaults > init.default.yaml

### 2.2.3
	kubeadm config images pull --config=init-config.yaml

### 2.2.4
	kubeadm init --config=init-config.yaml   # log-> init-config

	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

	kubectl get -n kube-system configmap


### 2.2.5
	yum install -y kubelet-1.14.1  kubeadm-1.14.1   #for other nodes join
