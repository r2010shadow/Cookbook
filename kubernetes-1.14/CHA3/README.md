## Kubernetes 1.14 Chapter 3


### 3.2
	kubectl create -f frontend-localredis-pod.yaml

#### test pod
	docker run -p 6379:6379 -d redis:latest redis-server
	docker exec -it CNAME redis-cli -h POD-IP -p 6379



