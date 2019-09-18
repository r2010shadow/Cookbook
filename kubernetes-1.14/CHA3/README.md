## Kubernetes 1.14 Chapter 3


### 3.2
	kubectl create -f frontend-localredis-pod.yaml

#### test pod
	docker run -p 6379:6379 -d redis:latest redis-server
	docker exec -it CNAME redis-cli -h POD-IP -p 6379


### 3.4 Volume by Multi pod use
	kubectl create -f pod-volume-applogs.yaml
	kubectl logs volume-pod -c busybox
	kubectl exec -it volume-pod -c tomcat -- ls /usr/local/tomcat/logs/
	kubectl exec -it volume-pod -c busybox -- ls /logs/

### 3.5 
	kubectl create -f cm-appvars.yaml
	kubectl get configmap
	kubectl describe configmap cm-appvars
	kubectl get configmap cm-appvars -o yaml

### 3.9

#### 定向调度 1. 为nodes加label标签  2. pod中指定nodeSelector的zone  
       kubectl label nodes vmnode zone=north
       kubectl label nodes vmnode2 zone=south

#### Taints & Tolerations
       kubectl taint nodes vmnode2 key=value:NoSchedule
       kubectl taint nodes vmnode2 key-

#### Job
       mkdir jobs
       for i in apple banana cherry; do cat job.yaml.txt | sed "s/\$ITEM/$i/" > ./jobs/job-$i.yaml; done
       kubectl create -f jobs    # under folder jobs has 3 yaml files.
       kubectl get jobs -l jobgroup=jobexample       

#### 自定义调度器
       kubectl create -f my-scheduler.yaml
       kubectl proxy  # Starting to serve on 127.0.0.1:8001
       sh my-scheduler.sh
       # nginx 1/1     Running  0 3m31s   10.40.0.2   kubemaster（这里不是node结点）

#### Init Container
       kubectl exec -it nginx cat /usr/share/nginx/html/index.html | grep "<title>Production-Grade Container Orchestration - Kubernetes"


#### Pod update
       kubectl create -f nginx-deployment-update.yaml
##### 1. kubectl set image
       kubectl set image deployment/nginx-deployment-update nginx=nginx:1.9.1 
##### 2. kubectl edit 
       kubectl edit deployment/nginx-deployment-update
##### check update status
       kubectl rollout status deployment/nginx-deployment-update
       kubectl describe deployment/nginx-deployment-update
       kubectl get rs


#### Pod undo
       kubectl set image deployment/nginx-deployment-update nginx=nginx:1.91  # test
       kubectl rollout status deployments nginx-deployment
       kubectl rollout history deployment/nginx-deployment-update       # view revision
       kubectl rollout undo deployment/nginx-deployment-update  # --to-revision=2

##### Pod puase & resume
       kubectl rollout pause deployment/nginx-deployment-update
       kubectl set image deployment/nginx-deployment-update nginx=nginx:1.9.3
       kubectl set resources deployment nginx-deployment-update -c=nginx --limits=cpu=200m,memory=512Mi
       kubectl rollout resume deployment/nginx-deployment-update


##### RC update. kubectl rolling-update 
       ./cre redis-master-controller-v1.yaml
###### update method 1.
         kubectl rolling-update redis-master -f redis-master-controller-vlatest.yaml --update-period=1s
###### update method 2.  Notice! Label do not change
         kubectl rolling-update redis-master --image=kubeguide/redis-master:latest --update-period=1s
       watch ./get rc      # -> rolling-update.log 
##### RC rolling-back
       kubectl rolling-update redis-master -f redis-master-controller-rollback-v1.yaml --update-period=1s
###### Tips: 1. RC name should not be same . 2. RC dont have history  3. RC instead by RS and Deployment.   suggest use Deployment update pod.




