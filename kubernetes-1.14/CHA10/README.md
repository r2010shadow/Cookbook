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

###  10.4.2
    ./cre crens limit-example 
    ./dc limits mylimits nsname limit-example
    kubectl run nginx --image=nginx --replicas=1 --namespace=limit-example
    kubectl get pods nginx-7db9fccd9b-cn2wb --namespace=limit-example -o yaml | grep resources -C 8


### 10.4.5 
    kubectl run nginx --image=nginx --replicas=1 --namespace=quota-example     # Failed create , Dont set CPU&MEM Limits and Requests

    kubectl run nginx --image=nginx --replicas=1 --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi --namespace=quota-example
