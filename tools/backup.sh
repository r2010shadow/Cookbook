#!/bin/bash


# Color
## blue to echo 
function BL(){
    echo -e "\033[35m[ $1 ]\033[0m"
}


## green to echo 
function GR(){
    echo -e "\033[32m[ $1 ]\033[0m"
}

## Error
function ERR(){
    echo -e "\033[31m\033[01m[ $1 ]\033[0m"
}

## warning
function WAR(){
    echo -e "\033[33m\033[01m[ $1 ]\033[0m"
}


# VAR
APP=$*
HOSTNAME=`hostname`
IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
FOLDER=$APP-$HOSTNAME-$IP


# Floder check && build


if [ ! -d "$FOLDER" ]; then
	mkdir -p /data/backup/$FOLDER
        if [ $? -eq 0 ]; then
                GR "/data/backup/$FOLDER"
        else
                ERR "Failed Create Folder"
        fi
fi
