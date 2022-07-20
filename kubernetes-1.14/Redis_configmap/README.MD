[Redis使用configmap](https://kubernetes.io/zh-cn/docs/tutorials/configuration/configure-redis-using-configmap/)

* Step

| STEPS                                                        |                                                  |
| ------------------------------------------------------------ | ------------------------------------------------ |
| kubectl apply -f example-redis-config.yaml                   |                                                  |
| kubectl apply -f https://k8s.io/examples/pods/config/redis-pod.yaml | 接收configmap的配置值                            |
| kubectl get pod/redis configmap/example-redis-config         |                                                  |
| kubectl describe configmap/example-redis-config              | redis-config: 空                                 |
| kubectl exec -it redis -- redis-cli                          |                                                  |
| 127.0.0.1:6379> CONFIG GET maxmemory                         | 1) "maxmemory" 2) "0"                            |
| 127.0.0.1:6379> CONFIG GET maxmemory-policy                  |                                                  |
| 在Configmap添加内容                                          | maxmemory 2mb   <br>maxmemory-policy allkeys-lru |
| kubectl apply -f example-redis-config.yaml                   | 改动更新                                         |
| kubectl describe configmap/example-redis-config              |                                                  |
| 127.0.0.1:6379> CONFIG GET maxmemory                         | 内容未更新，需要重建pod                          |
| kubectl delete pod redis                                     |                                                  |
| kubectl apply -f https://k8s.io/examples/pods/config/redis-pod.yaml |                                                  |
| 127.0.0.1:6379> CONFIG GET maxmemory                         |                                                  |

