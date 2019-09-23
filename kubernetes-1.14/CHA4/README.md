## Kubernetes 1.14 Chapter 4

### 4.2
    ./get pods -l app=webapp -o yaml | grep podIP   # do not work!
    
##### Create RC   The balance of the services.
      kubectl expose rc webapp       # method 1.
      ./cre webapp-rc-service.yaml   # method 2.
      curl $IP:8081

###### Case: cassandra  link:https://www.kubernetes.org.cn/doc-36
    ./cre cassandra-service.yaml
    ./cre cassandra.yaml   
    ./cre cassandra-rc.yaml
    ./sca cassandra 4
    ./it cassandra -- nodetool status      # dont see balance status!
###### Error log from pod cassandra
    INFO  06:47:24 Getting endpoints from https://kubernetes.default.cluster.local/api/v1/namespaces/default/endpoints/cassandra
    WARN  06:47:24 Request to kubernetes apiserver failed
    java.net.ConnectException: Connection refused

#### 4.4.2 Error
    The Service "webapp" is invalid: spec.ports[0].nodePort: Invalid value: 8081: provided port is not in the valid range. The range of valid ports is 30000-32767

#### 4.5
    ./get deployment --namespace=kube-system
    ./get pods --namespace=kube-system
    ./get services --namespace=kube-system
    
    ./it busybox -- nslookup cassandra
###### Name:      cassandra
###### Address 1: 10.111.190.212 cassandra.default.svc.cluster.local

    ./it busybox -- nslookup kube-dns.kube-system
###### Name:      kube-dns.kube-system
###### Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

    ./it dns-example cat /etc/resolv.conf

#### 4.6 Ingress    more info:https://www.cnblogs.com/terrycy/p/10048165.html
    
