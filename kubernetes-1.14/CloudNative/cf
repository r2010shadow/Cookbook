#!/bin/bash


if [ -z $1 ]; then
 echo -e "\033[1;32m  kubectl config view"
 kubectl config view
 echo "Mode: ./cf [ set | del ] NAME NAMESPACE CLUSTER USER"
 exit
fi

if [ $1 == set ]; then
 echo -e "\033[1;32m  kubectl config set-context $2 --namespace=$3 --cluster=$4 --user=$5"
 kubectl config set-context $2 --namespace=$3 --cluster=$4 --user=$5
 echo " "
 exit
fi

if [ $1 == use ]; then
  echo -e "\033[1;32m  kubectl config use-context $2"
  kubectl config use-context $2
  exit
fi


if [ $1 == del ]; then
 echo -e "\033[1;32m  kubectl config delete-context $2 --namespace=$3 --cluster=$4 --user=$5"
 kubectl config delete-context $2 --namespace=$3 --cluster=$4 --user=$5
 echo " "
 exit
fi

echo -e "\033[1;32m  kubectl config $1 $2 $3 $4"
kubectl config $1 $2 $3 $4
