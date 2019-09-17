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





