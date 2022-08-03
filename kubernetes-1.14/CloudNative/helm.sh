#!/bin/bash

if [ -z $1 ]; then
 echo -e "\033[1;32m helm ls"
 helm ls
 exit
fi


if [[ $1 == 'ins' ]]; then
  if [ -z $2 ];then
    echo -e "\033[1;32m  Warning! Name input Needed. "
    exit
  fi
  echo -e "$T \033[1;32m helm install --name $2 $3"
  helm install --name $2 $3
  exit
fi

if [[ $1 == 'del' ]]; then
  echo -e "$T \033[1;32m helm delete $2"
  helm delete $2
  helm ls
  exit
fi

if [[ $1 == 'delp' ]]; then
  echo -e "$T \033[1;32m helm delete --purge $2"
  helm delete --purge $2
  helm ls
  exit
fi

if [[ $1 == 'sta' ]]; then
  echo -e "$T \033[1;32m helm status $2"
  helm status $2
  exit
fi

if [[ $1 == 'all' ]]; then
  echo -e "$T \033[1;32m helm ls --all"
  helm ls --all
  exit
fi

echo -e "$T \033[1;32m helm $1 $2 $3 $4"
helm $1 $2 $3 $4






