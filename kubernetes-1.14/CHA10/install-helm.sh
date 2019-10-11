#!/bin/bash

# helm
cd /tmp/
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.2-linux-amd64.tar.gz
tar xf helm-v2.11.0-linux-amd64.tar.gz
cp linux-amd64/helm  /usr/local/bin/helm
helm help | head -n 1

# Role-based Access Control  : https://github.com/helm/helm/blob/master/docs/rbac.md
# kubectl create -f rbac-config.yaml

# tiller 
helm init --upgrade --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.12.2 \
 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

helm version


# Error: release roy-kafka failed: namespaces "default" is forbidden: User "system:serviceaccount:kube-system:default" cannot get resource "namespaces" in API group "" in the namespace "default"
# ToDo:
# kubectl create serviceaccount --namespace kube-system tiller
# kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

# more info: 
# https://blog.csdn.net/dayi_123/article/details/91874659
# https://www.kubernetes.org.cn/3435.html
# https://www.cnblogs.com/fawaikuangtu123/p/11296574.html


