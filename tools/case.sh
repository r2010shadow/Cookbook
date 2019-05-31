#!/bin/bash


date01=`date +%Y%m%d`
date02=`date -d "-7day" +%Y%m%d`

cd /root/scripts/mssql

tsql -H 10.10.2.16 -p 1433 -U nesoft_some -P box_some@123 < user.sql  > usertmp.txt

./txt2excel.sh user.txt user_utf8.xls
unix2dos user_utf8.xls
iconv -f UTF-8 -t GBK -c user_utf8.xls > user.xls

tsql -H 10.10.2.10 -p 1433 -U nesoft_some -P box_some@123 < order.sql > ordertmp.txt
cat ordertmp.txt | grep -v "UTF-8" | sed 's/1> 2> 3> 4> 5> 6> 7> 8> 9> 10> 11> 12> 13> 14> 15> 16> 17> 18> 19> 20> 21> 22> 23> 24> 25> 26> 27> 28> 29> 30> 31> 32> 33> 34> 35> 36> 37> 38> 39> 40> 41> 42> 43> 44> 45> 46> 47> 48> 49> 50> 51> 52> 53> 54> //g' | sed 's/ / /g' | sed '$d' | sed '$d' | sed 's/:[0-9][0-9][0-9]AM/ AM/g' | sed 's/:[0-9][0-9][0-9]PM/ PM/g' | sed 's/Jan\ \ /Jan\ 0/g' | sed 's/Feb\ \ /Feb\ 0/g' | sed 's/Mar\ \ /Mar\ 0/g' | sed 's/Apr\ \ /Apr\ 0/g' | sed 's/May\ \ /May\ 0/g' | sed 's/Jun\ \ /Jun\ 0/g' | sed 's/Jul\ \ /Jul\ 0/g' | sed 's/Aug\ \ /Aug\ 0/g' | sed 's/Sep\ \ /Sep\ 0/g' | sed 's/Oct\ \ /Oct\ 0/g' | sed 's/Nov\ \ /Nov\ 0/g' | sed 's/Dec\ \ /Dec\ 0/g'> order.txt
./txt2excel.sh order.txt order_utf8.xls
unix2dos order_utf8.xls
iconv -f UTF-8 -t GBK -c order_utf8.xls > order.xls

tsql -H 10.10.2.10 -p 1433 -U nesoft_some -P box_some@123 < product.sql > producttmp.txt
cat producttmp.txt | grep -v "UTF-8" | sed 's/1> 2> 3> 4> 5> 6> 7> 8> //g' | sed 's/ / /g' | sed '$d' | sed '$d' | sed 's/:[0-9][0-9][0-9]AM/ AM/g' | sed 's/:[0-9][0-9][0-9]PM/ PM/g' | sed 's/Jan\ \ /Jan\ 0/g' | sed 's/Feb\ \ /Feb\ 0/g' | sed 's/Mar\ \ /Mar\ 0/g' | sed 's/Apr\ \ /Apr\ 0/g' | sed 's/May\ \ /May\ 0/g' | sed 's/Jun\ \ /Jun\ 0/g' | sed 's/Jul\ \ /Jul\ 0/g' | sed 's/Aug\ \ /Aug\ 0/g' | sed 's/Sep\ \ /Sep\ 0/g' | sed 's/Oct\ \ /Oct\ 0/g' | sed 's/Nov\ \ /Nov\ 0/g' | sed 's/Dec\ \ /Dec\ 0/g'> product.txt
./txt2excel.sh product.txt product_utf8.xls
unix2dos product_utf8.xls
iconv -f UTF-8 -t GBK -c product_utf8.xls > product.xls

tar -zcf "$date01"_sql.tar.gz user.xls order.xls product.xls

#订单数插入mysql
#checkorder=`cat order.txt | grep -v "订单时间" | wc -l`
#/usr/local/mysql/bin/mysql -h 10.10.6.51 -uroot -psome123456 -D test  -e "INSERT INTO orders values('$date01','$checkorder');"

#发送前一日订单数
checksql=`ls /root/scripts/mssql | grep "$date01" | wc -l`
checkorder=`cat order.txt | grep -v "订单时间" | wc -l`
if [ $checksql  = 1 ];then
  /usr/local/sbin/sendEmail -f Service@smtp.some.com -t fox@some.com  -s 10.10.6.27 -u "$date01 orders" -m "$checkorder" -o message-charset=utf8 -xu Service@smtp.some.com -xp box_some@123
fi

#发送前一日mssql邮件

checksql=`ls /root/scripts/mssql | grep "$date01" | wc -l`
if [ $checksql  = 1 ];then
  /usr/local/sbin/sendEmail -f alert@some.com -t wei.yuxi@some.com\;shi.wen@some.com  -cc fox@some.com  -u "Daily SQL Report" -m "FYI" -a /root/scripts/mssql/"$date01"_sql.tar.gz  -o message-charset=utf8 -s mail.some.com:587 -xu alert -xp password 1>/root/scripts/mssql/sendmail.log
fi

#sleep 10

#checksend=`cat /root/scripts/mssql/sendmail.log | grep "ERROR" | wc -l`
#while [ $checksend -eq 1 ]
#do
#   sleep 5
#  /usr/local/sbin/sendEmail -f alert@some.com -t wei.yuxi@some.com\;wu.wenjie@some.com  -cc lu.qi@some.com  -u "Daily SQL Report" -m "FYI" -a /root/scripts/mssql/"$date01"_sql.tar.gz  -o message-charset=utf8 -s mail.some.com:587 -xu alert -xp password 1>/root/scripts/mssql/sendmail.log
#done

rm -f "$date02"_sql.tar.gz
#chown zabbix:zabbix order.xls
