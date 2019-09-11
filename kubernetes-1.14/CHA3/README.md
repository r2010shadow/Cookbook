## Kubernetes 1.14 Chapter 3


### 3.2
	kubectl create -f frontend-localredis-pod.yaml

#### test pod
	docker run -p 6379:6379 -d redis:latest redis-server
	docker exec -it CNAME redis-cli -h POD-IP -p 6379


### 3.4 Volume for multi pod use
	kubectl create -f pod-volume-applogs.yaml
	kubectl logs volume-pod -c busybox
	kubectl exec -it volume-pod -c tomcat -- ls /usr/local/tomcat/logs/
	kubectl exec -it volume-pod -c busybox -- ls /logs/

### 3.5 
	kubectl create -f cm-appvars.yaml
	kubectl get configmap
	kubectl describe configmap cm-appvars
	kubectl get configmap cm-appvars -o yaml








