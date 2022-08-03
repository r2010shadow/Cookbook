#!/bin/bash
if [ -z $1 ]; then
 echo -e "\033[1;32m kubectl create -f somefile.yaml"
 exit
fi

if [ $1 == crens ]; then
 echo -e "\033[1;32m kubectl create namespace $2"
 kubectl create namespace $2
 kubectl get namespaces
 exit
fi

if [ -z $2 ]; then
  echo -e "\033[1;32m kubectl create -f $1"
  kubectl create -f $1
  exit
fi

if [ $2 == usens ]; then
 echo -e "\033[1;32m kubectl create -f $1 --namespace=$3"
 kubectl create -f $1 --namespace=$3
 exit
fi


