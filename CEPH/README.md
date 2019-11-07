# CEPH


## pre

  [To All]

            systemctl disable firewalld.service
            systemctl stop firewalld.service
            sed -i.back "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
            grep disable /etc/selinux/config

            hostnamectl set-host admin-node  [ node..]
            hostname —fqdn

            useradd -d /home/userceph -m userceph
            passwd userceph
            echo "userceph ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/userceph
            chmod 0440 /etc/sudoers.d/userceph
            yum install yum-plugin-priorities -y

        cat >> /etc/hosts  <<EOF
        10.10.3.30 admin-node
        10.10.3.15 node-3-15
        10.10.3.104 node-3-104
        10.10.3.105 node-3-105
        EOF


  [admin]

            su userceph
            ssh-keygen
            ssh-copy-id userceph@admin-node
            ssh-copy-id userceph@node-3-16
            ssh-copy-id userceph@node-3-30

            cat >> /home/kjtceph/.ssh/config << EOF
                Host node1
                   Hostname node-3-16
                   User userceph
                Host node2
                   Hostname node-3-30
                   User userceph
                Host node3
                   Hostname admin-node-3-105
                   User userceph
                EOF
            chmod 600 /home/userceph/.ssh/config



            yum install ntp -y
            cat >> /etc/ntp.conf <<EOF
            restrict 10.10.3.0 mask 255.255.255.0 nomodify notrap
            EOF
            service ntpd start
            chkconfig ntpd on


  [admin CEPH]

            mkdir -p /home/app/my-cluster
            cd /home/app/my-cluster

            yum install -y yum-utils && sudo yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/ 
            && sudo yum install --nogpgcheck -y epel-release && sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 
            && sudo rm /etc/yum.repos.d/dl.fedoraproject.org*

            yum update &&  yum install ceph-deploy


  Create nodes:
            ceph-deploy new admin-node-3-105 node-3-16 node-3-30

  Active OSD:
            EDIT- /etc/ceph/ceph.conf

  Install nodes:
            ceph-deploy install  admin-node-3-105 node-3-16 node-3-30

  Monitor-keys:
            ceph-deploy mon create-initial


  [node]

  Add OSD @ each nodes hosts:
                #node-3-16 
                    mkdir /var/local/osd0
                    chown ceph:ceph /var/local/osd0
             
                #node-3-30         
                    mkdir /var/local/osd1
                    chown ceph:ceph /var/local/osd1
 
                #admin-node-3-105 
                    mkdir /var/local/osd2
                    chown ceph:ceph /var/local/osd2


  prepare & activate OSD
                    ceph-deploy osd prepare node-3-16:/var/local/osd0 node-3-30:/var/local/osd1 admin-node-3-105:/var/local/osd2
                    ceph-deploy osd activate node-3-16:/var/local/osd0 node-3-30:/var/local/osd1 admin-node-3-105:/var/local/osd2


  [CHECK Command]
  ceph health
  ceph osd tree
  ceph -s 
  ceph fs ls
  ceph mds stat
  ceph quorum_status --format json-pretty  检查法定人数状态

  [Single Mode for CEPH]
        systemctl stop firewalld.service
        systemctl disable firewalld.service
        yum install yum-plugin-priorities -y
        sed -i.back "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
        grep disable /etc/selinux/config
         
        hostnamectl set-hostname admins
        hostname —fqdn
         
        mkdir -p /home/app/my-cluster
        cd /home/app/my-cluster
        yum install -y yum-utils && sudo yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/ 
        && sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && sudo rm /etc/yum.repos.d/dl.fedoraproject.org*
        yum update -y

        yum install ceph-deploy -y

        echo "osd crush chooseleaf type = 0" >> ceph.conf
        echo "osd pool default size = 1" >> ceph.conf
        echo "osd journal size = 100" >> ceph.conf
        
        ceph-deploy install admins
        ceph-deploy mon create admins
        ceph-deploy mon create-initial
        ceph-deploy osd prepare admins:/dev/sdb
        ceph-deploy osd prepare admins:/dev/sdc
        lsblk
        ceph-deploy osd activate admins:/var/lib/ceph/osd/ceph-0
        ceph-deploy osd activate admins:/var/lib/ceph/osd/ceph-1
        ceph-deploy admin admins
        ceph-deploy --overwrite-conf mds create admins
        ceph osd pool create cephfs_data 8
        ceph osd pool create cephfs_metadata 10
        ceph fs new cephfs cephfs_metadata cephfs_data
        ceph fs ls
        ceph mds stat         -> e5: 1/1/1 up {0=admins=up:active}

  [USE CEPH]

  Add MDS:
                ceph-deploy mds create admin-node-3-105 

  ADD RGW:
                ceph-deploy rgw create node-3-105

  Send & Copy ceph.conf to all:
                ceph-deploy --overwrite-conf admin  node-3-16 node-3-30 admin-node-3-105

   存入/检出对象数据:
        rados lspools
        ceph osd lspools
        rados put test-object-1 testfile.txt --pool=rbd
        rados -p rbd ls
        ceph osd map rbd test-object-1
        rados rm test-object-1 --pool=rbd



  [Client]

        hostnamectl set-hostname ceph-client
        hostname --fqdn
        useradd -d /home/userceph -m userceph
        passwd userceph
        echo "userceph ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/userceph
        chmod 0440 /etc/sudoers.d/userceph

        cat >> /etc/hosts  <<EOF
        10.10.3.30 admin-node
        10.10.3.15 node-3-15
        10.10.3.104 node-3-104
        10.10.3.105 node-3-105
        EOF

  Set admin node:
            cat >> /etc/hosts <<EOF
            10.10.7.128 ceph-client
            EOF
            ssh-copy-id userceph@ceph-client   
            ceph-deploy install ceph-client
            ceph-deploy admin ceph-client



  Set client:
            rbd create foo --size 4096  -m node-3-15 -k /etc/ceph/ceph.client.admin.keyring
            rbd map foo --name client.admin -m node-3-15 -k /etc/ceph/ceph.client.admin.keyring



  [CEPH-FS]

            ceph osd pool create cephfs_data 8
            ceph osd pool create cephfs_metadata 10
            ceph fs new cephfs cephfs_metadata cephfs_data
            ceph fs ls
            ceph mds stat


  Cluster Use:
            mount -t ceph node-3-15:6789:/ /mnt/mycephfs -o 
                name=admin,secret=AQDRdvlZcTDKARAA2u4qTJBSRTT4y4cBxLnTJg=

  Single host Use:
            mount -t ceph 10.10.2.18:6789:/ /mnt/mycephfs-2-18 -o 
                name=admin,secret=AQDidAJaCEYwHBAA/EPcKz5HaHrnHycDULHqnQ==

  secret files:
            /home/app/my-cluster/ceph.client.admin.keyring


  [ceph.conf]

                ceph-deploy admin admin-node node-3-15 node-3-104 node-3-105
                chmod +r /etc/ceph/ceph.client.admin.keyring

  [Ceph reset]
  
  Clean conf:
            ceph-deploy purgedata admin-node-3-105 node-3-16 node-3-30

  Delete package:
            ceph-deploy purge admin-node-3-105 node-3-16 node-3-30


  Add OSD:
                    mkdir /var/local/osdx
                    chown ceph:ceph /var/local/osdx
                    ceph-deploy osd prepare nodes:/var/local/osdx
                    ceph-deploy osd activate nodes:/var/local/osdx

  [Error]
  OSD down:
            check ceph.conf [osd pool default size]
            ceph-deploy osd activate [nodes]

  rbd: sysfs write failed
            EDIT:ceph.conf  -> 在global 下，增加 
            rbd_default_features = 1
            ceph-deploy --overwrite-conf admin  admin-node node-3-15 node-3-104 node-3-105 ceph-client

  RuntimeError: NoSectionError: No section: ‘ceph'
            yum remove ceph-release
            ceph-deploy install


   ceph_disk.main.Error: Error: ceph osd create failed: Command '/usr/bin/ceph' returned non-zero exit status 1: 2017-11-02             16:12:43.325390 7fe6d978e700  0 librados: client.bootstrap-osd authentication error (1) Operation not permitted
        scp ceph.client.admin.keyring node-3-105:/etc/ceph/
        在node上执行，不必删客户端程序
        ps -ef | grep ceph |awk '{print $2}'|xargs kill -9
        umount /var/lib/ceph/osd/*
        rm -rf /var/lib/ceph/osd/*
        rm -rf /var/lib/ceph/mon/*
        rm -rf /var/lib/ceph/mds/*
        rm -rf /var/lib/ceph/bootstrap-mds/*
        rm -rf /var/lib/ceph/bootstrap-osd/*
        rm -rf /var/lib/ceph/bootstrap-rgw/*
        rm -rf /var/lib/ceph/tmp/*
        rm -rf /etc/ceph/*
        rm -rf /var/run/ceph/*
        在admin-node上执行 OSD激活

  ceph health detail: HEALTH_WARN 1 mons down, quorum 0,1 node-3-15,node-3-104
    todo 1
        ceph-deploy --overwrite-conf mon create node-3-105
        ceph mon add node-3-105 10.10.3.105:6789
    todo 2
        service ceph -c/etc/ceph/ceph.conf start node-3-105 
        ceph mon remove node-3-105
    todo 3 
        public network = 10.10.3.0/24 
        ceph-deploy mon add node-3-105
        ceph mon add node-3-105 10.10.3.105:6789  

  [CEPH+CLOUDSTACK]

        Edit: ceph.conf 
        yum install  rbd-fuse python-ceph-compat python-rbd librbd1-devel  -y

  二级存储:
        mkdir /storage/stagingsecondary -p
cat << EOF > /etc/exports
/storage/stagingsecondary      *(insecure,rw,fsid=1,sync,no_root_squash,no_subtree_check)
EOF
        exportfs -a
        ceph-fuse -m 10.10.3.105:6789 /storage/stagingsecondary

  Test:
        dd if=/dev/zero of=/storage/StagingSecondary/file1 count=100 bs=1M

  kvm虚拟机导入:
        mkdir -p /tmp/iso
        mount -t nfs -o nolock 127.0.0.1:/storage/stagingsecondary/ /tmp/iso/
        wget http://cloudstack.apt-get.eu/systemvm/4.6/systemvm64template-4.6.0-kvm.qcow2.bz2 -P /opt/src
        /usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /storage/stagingsecondary -f /opt/src/systemvm64template-4.6.0-kvm.qcow2.bz2 -h kvm -F
        umount /tmp/iso/








