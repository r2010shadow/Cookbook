#!/bin/bash

if [[ $2 == 'ks' ]]; then
  echo -e "$T \033[1;32m kubectl log $1 --namespace=kube-system"
  kubectl log $1 --namespace=kube-system
  exit
fi

if [[ $2 == 'name' ]]; then
  echo -e "$T \033[1;32m kubectl log -f  $1 --namespace=$3"
  kubectl log -f $1 --namespace=$3
  exit
fi

echo -e "$T \033[1;32m kubectl log -f $1 $2" 
kubectl logs -f $1 $2 
