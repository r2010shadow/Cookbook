### High Availability


### HAProxy
    yum install -y haproxy
    EDIT:     /etc/haproxy/haproxy.cfg   
    systemctl enable haproxy && systemctl start haproxy
    VISIT:    IP:12345/stats



### master 1

  yum install -y kubelet-1.14.1  kubectl-1.14.1 kubeadm-1.14.1
  systemctl enable kubelet
  kubeadm  config images pull  --config init-config-aliyun.yaml

  systemctl cat kubelet   # check config

  kubeadm init --config=init-config-aliyun.yaml --experimental-upload-certs  | kubeadm-init.log

## CNI : weave   |   STATUS : NotReady.  coredns : pending
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


# master [2-3]


## docker
  wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

  yum install -y docker-ce-18.09.3

  systemctl enable docker && systemctl start docker






















# more
  https://www.ucloud.cn/yun/32964.html   kubeadm部署1.14版本高可用集群
  https://www.jianshu.com/p/dba30d617a3f kubeadm部署多节点master集群

