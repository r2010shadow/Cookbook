## Kubernetes 1.14 Chapter 2


### 2.1  Docker
	wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

	yum install -y docker-ce-18.09.3

	systemctl enable docker && systemctl start docker

#### TIPS: Container runtimes 
#### Webiste: https://kubernetes.io/docs/setup/production-environment/container-runtimes/

	yum install -y yum-utils device-mapper-persistent-data lvm2
	mkdir /etc/docker
	mkdir -p /etc/systemd/system/docker.service.d

	load  /etc/docker/daemon.json  @ -> daemon.json 
	systemctl daemon-reload
	systemctl restart docker


### 2.2.1 Kube Master deploy
	load repo @ -> kubernetes.repo
	yum install -y kubelet-1.14.1  kubectl-1.14.1 kubeadm-1.14.1

### 2.2.2 kubeadmin config
	kubeadm config print init-defaults > init.default.yaml

### 2.2.3 pull images
	kubeadm config images pull --config=init-config.yaml

### 2.2.4 master initing
	kubeadm init --config=init-config.yaml   # log-> init-config

	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

	kubectl get -n kube-system configmap


### 2.2.5  kube Nodes deploy
#### Join master
	yum install -y kubelet-1.14.1  kubeadm-1.14.1   #for other nodes join
	Operater #2.1 install docker	

	kubeadm join --config=join-config.yaml  # log -> join-config

#### All-In-One
	
	kubectl taint nodes --all node-role.kubernetes.io/master-





