#!/bin/bash
USER_LIST="$1"
SUBJECT="$2"
MESSAGE="$3"
/usr/local/bin/sendEmail -f mail@smtp.x.com -t $USER_LIST -u $SUBJECT -m $MESSAGE -o message-charset=utf8 -s 10.10.x.x -xu Service@smtp.x.com -xp somemail@123
