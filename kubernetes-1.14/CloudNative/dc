#!/bin/bash

if [ -z $1 ]; then
 echo -e "$T \033[1;32m kubectl describe [ POD/PODNAMES ] " 
 exit
fi

if [ $1 == help ]; then
 echo 'kubectl describe deployment/nginx-deployment-update'
 exit
fi

if [[ $3 == 'ks' ]]; then
  echo -e "$T \033[1;32m kubectl describe $1 $2 --namespace=kube-system"
  kubectl describe $1 $2 --namespace=kube-system
  exit
fi

if [[ $3 == 'usens' ]]; then
  echo -e "$T \033[1;32m kubectl describe $1 $2 --namespace=$4"
  kubectl describe $1 $2 --namespace=$4
  exit
fi

if [[ $2 == 'usens' ]]; then
  echo -e "$T \033[1;32m kubectl describe $1 --namespace=$3"
  kubectl describe $1  --namespace=$3
  exit
fi

echo -e "\033[1;32m kubectl describe $1 $2"
kubectl describe $1 $2



