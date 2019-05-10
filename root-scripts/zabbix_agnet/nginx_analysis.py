#!/usr/bin/env python
#-*- coding:utf-8 -*-
__author__ = 'Don'

from os import system
import datetime

Format = '%d/%b/%Y:%H:%M'
LastMinute = (datetime.datetime.today()-datetime.timedelta(minutes=1)).strftime(Format)
print LastMinute
#LastMinute = '09/Apr/2016:11:27'
MatchRecord = 'www.x.com'
LogPath = '/data/logs/nginx/access.log'

def GetLastLine():
    '''取最后一行数据'''
    global pos,flag
    while True:
        pos = pos - 1
        try:
            f.seek(pos, 2)                #从文件末尾的前一个字节开始读
            if f.read(1) == '\n':
                break
        except:                           #到达文件第一行，直接读取，退出
            if flag == False:
                f.seek(0, 0)
                flag = True
                return f.readline().strip()
    return f.readline().strip()

def HandleData():
    '''处理数据'''
    if flag:
        print "fail"
        return                        #当flag标志为True，说明到达文件第一行，直接return
    if len(GetLastLine()) == 0:
        print "kong"
        return     #返回空行，直接return
    print GetLastLine()
    last_line = GetLastLine().split()
    #print LastMinute
    #print last_line[5][1:-3]
    global record_list
    #if last_line[0] != "-":
    if last_line[5][1:-3] == LastMinute and last_line[7] == MatchRecord:
        record_list.append(float(last_line[0]))

if __name__ == "__main__":
    with open(LogPath,'r') as f:            #‘r’的话会有两个\n\n
        pos = 0
        flag = False
        record_list = []
        for line in range(50000):            #需要倒数多少行就循环多少次
            #HandleData()
            print GetLastLine()
        # print record_list
        print len(record_list)
        print sum(record_list)
        record_list.sort()                 #列表排序
        record_list =  record_list[2:-2]   #去除两个最大值和最小值
        request_avg =  sum(record_list)/len(record_list)   #总数除以数量
        request_avg_2 = float('%0.2f'%request_avg)         #取小数点后两位
        print request_avg_2
