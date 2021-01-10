#!/bin/bash


pwfile="/etc/passwd"
shadowfile="/etc/shadow"
gfile="/etc/group"
hdir="/home"
shadowid=`cat /etc/shadow  | awk -F":" '{print $3}' | head -n 1`

if [ "$(id -un)" != "root" ] ; then
	echo "Error: You must be root to run this command." >&2
	exit 1
fi


echo "Add new user account to $(hostname)"
echo -n "login:" ; read  login


uid = "$(awk -F: '{ if (big < $3 && $3 < 5000 ) big=$3 } END { print big + 1 }' $pwfile)"
homedir=$hdir/$login


gid=$uid

echo -n "full name: "; read fullname
echo -n "shell: "; read shell


echo "Setting up account $login for $fullname..."

echo ${login}:x:${uid}:${gid}:${fullname}:${homedir}:$shell >> $pwfile
echo ${login}:*:${shadowid}:0:99999:7::: >> $shadowfile


echo "${login}:x:${gid}:$login" >> $gfile

mkdir $homedir

cp -R /etc/skel/.[a-zA-Z]* $homedir
chmod 755 $homedir
chown -R ${login}:${login} $homedir

exec passwd $login
