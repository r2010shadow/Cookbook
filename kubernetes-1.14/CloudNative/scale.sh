#!/bin/bash

if [ $1 == help ]; then
 echo 'kubectl scale -h'
 exit
fi


if [ $1 == dep ]; then
 echo '\033[1;32m kubectl scale deployment $2'
 kubectl scale deployment $2 --replicas=$3
 kubectl get deployment
 exit
fi

if [ $1 == rc ]; then
 echo '\033[1;32m kubectl scale rc $2'
 kubectl scale rc  $2 --replicas=$3
 kubectl get rc
 exit
fi




