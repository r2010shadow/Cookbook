# High Availability


## Mode A: Stack case

### PRE

  <system>
  sed -i '7s#enforcing#disabled#g' /etc/selinux/config
  systemctl stop firewalld.service
  systemctl disable firewalld.service


  <Docker>
  wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
  yum install -y docker-ce-18.09.3
  systemctl enable docker && systemctl start docker

### HAProxy [Double] 

  [rsyslog]
  mkdir /var/log/haproxy
  chmod a+w /var/log/haproxy

  EDIT: /etc/rsyslog.conf
   将如下两行得注释取消
    $ModLoad imudp
    $UDPServerRun 514
   在该文件添加如下内容：
    # Save haproxy log
    local3.*                       /var/log/haproxy/haproxy.log
  
  EDIT: /etc/sysconfig/rsyslog
   SYSLOGD_OPTIONS="-r -m 0 -c 2"

  touch /var/log/haproxy/haproxy.log
  systemctl restart rsyslog.service

  [HAProxy]
  yum install -y haproxy
  EDIT:     /etc/haproxy/haproxy.cfg    # rsyslog <- log 127.0.0.1 local3 info  
  systemctl enable haproxy && systemctl start haproxy
  VISIT:    IP:12345/stats
  tailf /var/log/haproxy/haproxy.log



### keeplive [Double]
  yum install keepalived -y
 

### master 1

  yum install -y kubelet-1.14.1  kubectl-1.14.1 kubeadm-1.14.1
  systemctl enable kubelet
  
  kubeadm  config images pull  --config init-config-aliyun.yaml
  kubeadm init --config=init-config-aliyun.yaml --experimental-upload-certs  | tee kubeadm-init.log

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config


  <CNI>
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  kubectl get no
  systemctl restart kubelet

  (check)
  systemctl cat kubelet                  # check config
  systemctl status kubelet -l | grep started  | awk -F 'pod' {'print $2'}
  systemctl status kubelet -l | grep started  | awk -F '"' {'print $2'} | uniq | wc -l
  kubectl get pods --namespace=kube-system  | grep -v NAME  | grep -v weave
  docker ps | awk -F 'POD_' '{print $2}' | awk -F '_kube-system' '{print $1}' | sort -r




### master [2-3]
  
  kubeadm join 10.10.9.109:12567 --token vece8z.81km6d8z59ujgk9k \
    --discovery-token-ca-cert-hash sha256:4b61f12d0833daeaa7c2ed399046910eba8717a8be1d6e090647a8ae9bbda18e \
    --experimental-control-plane --certificate-key 3fed95b9dbe7098dfc97449dd8301bc59cd95ce539fe52c13891141bfc6bc79b

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  systemctl restart kubelet
  (check)

### node [1-n]

  [if exist] kubeadm reset
  kubeadm join 10.10.9.109:12567 --token vece8z.81km6d8z59ujgk9k \
    --discovery-token-ca-cert-hash sha256:4b61f12d0833daeaa7c2ed399046910eba8717a8be1d6e090647a8ae9bbda18e




## mode B: outside etcd case




















# more
  https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/ 
  https://www.ucloud.cn/yun/32964.html   kubeadm部署1.14版本高可用集群
  https://www.jianshu.com/p/dba30d617a3f kubeadm部署多节点master集群
  https://www.cnblogs.com/cptao/p/10907833.html
