#!/bin/bash

if [ -z $1 ]; then
 echo kubectl get pods PODNAME -o yaml
 exit
fi

if [ $3 == nsname ];then
 echo -e "\033[1;32m kubectl get $1 $2 --namespace=$4 -o yaml"
 kubectl get $1 $2 --namespace=$4 -o yaml
 exit
fi 

echo -e "\033[1;32m kubectl get $1 $2 -o yaml"
kubectl get $1 $2 -o yaml
