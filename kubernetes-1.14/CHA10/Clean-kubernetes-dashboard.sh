#!/bin/bahs

kubectl get svc kubernetes-dashboard  --namespace=kube-system   > /dev/null 2>&1
if [ $? -eq 0 ];then
 echo "Find it. start clean..."
 if [ ! -f del ];then
  ./del svc kubernetes-dashboard ks
  ./del deployment kubernetes-dashboard ks
  ./del secret kubernetes-dashboard-certs ks
  ./del secret kubernetes-dashboard-key-holder ks
  ./del role kubernetes-dashboard-minimal ks
  ./del rolebinding kubernetes-dashboard-minimal ks
  ./del serviceaccounts kubernetes-dashboard ks
 fi
else
 echo "Dont find it."
fi

