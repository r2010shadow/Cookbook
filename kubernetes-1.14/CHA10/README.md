## Kubernetes 1.14 Chapter 10

###  10.3.2 Context
    ./cf set ct-dev development kubernetes kubernetes-admin
    ./cf use ct-dev       # Switched to context "ct-dev". 
    ./cre redis-slave-controller.yaml  

    ./cf set ct-prod production kubernetes kubernetes-admin
    ./cf use ct-prod      # Switched to context "ct-prod".
    ./cre redis-slave-controller.yaml

    ./cf use kubernetes-admin@kubernetes    # Switched to Default context. 

#### Q. How to see All Context status once.
     kubectl get po,no --all-namespaces -owide

###  10.4.2
    ./cre crens limit-example 
    ./dc limits mylimits nsname limit-example
    kubectl run nginx --image=nginx --replicas=1 --namespace=limit-example
    kubectl get pods nginx-7db9fccd9b-cn2wb --namespace=limit-example -o yaml | grep resources -C 8


### 10.4.5 ResourceQuota & LimitRange EX. 
    kubectl run nginx --image=nginx --replicas=1 --namespace=quota-example     # Failed create , Dont set CPU&MEM Limits and Requests

    kubectl run nginx --image=nginx --replicas=1 --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi --namespace=quota-example

    kubectl run best-effort-nginx --image=nginx --replicas=8 --namespace=quota-scopes
    kubectl run not-effort-nginx  --image=nginx --replicas=2 --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi  --namespace=quota-scopes





### 10.11 WEB UI Bashboard
     WEBSITE: https://github.com/kubernetes/dashboard
  
     wget https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
     EDIT:kubernetes-dashboard.yaml [image/type: NodePort/nodePort: 30000] and commit part of - Dashboard Secret -

     ./cre kubernetes-dashboard.yaml  # Use Clean*.sh to reset.
     VIEW: https://10.10.6.110:30000  # paste token as fellow step


#### Make and Use RSA
     openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
     openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key
     openssl req -new -key dashboard.key -out dashboard.csr -subj "/C=CN/ST=SH/L=SH/O=Sin/OU=IT/CN=10.10.6.110"
     openssl x509 -req -in dashboard.csr -signkey dashboard.key -out dashboard.crt

     kubectl -n kube-system create secret generic kubernetes-dashboard-certs --from-file=dashboard.key --from-file=dashboard.crt

##### craete user case 1 - logged in as an admin
     WEBSITE:https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
     ./cre crens kubernetes-dashboard  # create namespace
     ./cre dashboard-adminuser.yaml    # create user
     kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
     VIEW: paste token to browser.

##### create user case 2 - logged in as normal user
     kubectl create serviceaccount def-ns-admin -n default
     kubectl create rolebinding def-ns-admin --clusterrole=admin --serviceaccount=default:def-ns-admin
     kubectl describe secret   # copy and paste def-ns-admin-token Token to browser.

##### readmore: https://www.cnblogs.com/zydev/p/10314815.html    https://www.jianshu.com/p/c6d560d12d50
