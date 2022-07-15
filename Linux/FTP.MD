# vsftp
```
Case: Add user 

ftpuser_add.sh
#!/bin/bash
# note: run script with newname


if [ -z $1 ]; then
 echo "[WARNING] ftp username is Needed."
 exit
fi

echo "$1" >>  /etc/vsftpd/vlogin.txt
mkpasswd -l 16 -d 5 -c 5 -C 5 >> /etc/vsftpd/vlogin.txt
db_load -T -t hash -f  /etc/vsftpd/vlogin.txt /etc/vsftpd/vlogin.db
chmod 600 /etc/vsftpd/vlogin.db

mkdir -p /var/ftp/$1
chown vsftpd:vsftpd /var/ftp/ -R

cat > /etc/vsftpd/user_config/$1 <<EOF
local_root=/var/ftp/$1
write_enable=YES
download_enable=YES
anon_world_readable_only=YES
anon_upload_enable=YES
anon_other_write_enable=YES
anon_mkdir_write_enable=YES
local_umask=022
EOF

/etc/init.d/vsftpd restart

[Case-END]
```
