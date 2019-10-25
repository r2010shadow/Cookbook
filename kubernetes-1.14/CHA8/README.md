## Kubernetes 1.14 Chapter 8


### 8.6 GlusterFs 

  [install to all]
  yum install centos-release-gluster -y
  yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma glusterfs-geo-replication glusterfs-devel
  systemctl enable glusterd && systemctl start glusterd 

  [add peer]
    gluster peer probe kmaster2
    gluster peer probe kmaster3

  [path]
    /etc/glusterfs/glusterd.vol   # path:  /var/lib/glusterd
    mkdir /opt/gfs_data

  [volume]
    gluster volume create k8s-volume transport tcp 10.10.6.110:/opt/gfs_data 10.10.9.243:/opt/gfs_data 10.10.9.112:/opt/gfs_data force
    gluster volume start k8s-volume

  [check]
    gluster peer status
    gluster volume info

  [case - static use gluster] 
    kubectl apply -f glusterfs-endpoints.json
    kubectl create -f glusterfs-service.json
    ./cre glusterfs-pv.yaml
    ./cre glusterfs-pvc.yaml



 




