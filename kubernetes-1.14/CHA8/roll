#!/bin/bash


if [ -z $1 ]; then
 echo -e '\033[1;32m kubectl rollout [status | undo | history | pause | resume] DEPLOYMENT DPNAMES'
 exit
fi


echo -e "\033[1;32m kubectl rollout $1 $2 $3"
kubectl rollout $1 $2 $3
