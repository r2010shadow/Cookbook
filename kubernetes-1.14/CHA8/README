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

### Heketi

  [master]
  yum install heketi -y
  
  Edit: /etc/heketi/heketi.json
        /usr/lib/systemd/system/heketi.service    # username , json path
  
  systemctl enable heketi  && systemctl start heketi && systemctl status heketi

  [user heketi]
  userdel heketi     # dont have /home/heketi
  useradd heketi
  echo 'heketi' | passwd --stdin heketi
  su - heketi
  echo "heketi    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
  modprobe dm_thin_pool
  chown heketi:heketi /etc/heketi/ -R || chown heketi:heketi /var/lib/heketi -R
  ssh-copy-id  heketi@10.10.6.112

  [node]
  yum install heketi-client -y
  
  Edit: /usr/share/heketi/topology-sample.json

  heketi-cli --server http://10.10.6.110:58080 --user admin --secret 123456 cluster list












  




 




