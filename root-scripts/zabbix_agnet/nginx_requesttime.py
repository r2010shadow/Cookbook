#!/usr/bin/env python
#-*- coding:utf-8 -*-
__author__ = 'Don'

import sys,datetime

Format = '%d/%b/%Y:%H:%M'
LastMinute = (datetime.datetime.today()-datetime.timedelta(minutes=1)).strftime(Format)   #取系统时间前一分钟
#print LastMinute
#LastMinute = '11/Apr/2016:14:00'
MatchRecord = sys.argv[1]
LogPath = '/data/logs/nginx/access.log'

def GetLastLine():
    '''列表返回文件数据'''
    with open(LogPath) as f:
        lines = f.readlines()
        return lines

def HandleData(row):
    '''处理返回数据'''
    global record_list
    if int(row) > len(GetLastLine()):         #判断要遍历的行数是否大于文件总行数
        rownumber = len(GetLastLine())        #大于则应用为文件总行数
    else:
        rownumber = int(row)                  #小于则应用为输入值
#    rownumber = int(row)
    for i in  GetLastLine()[-rownumber:]:     #遍历倒数多少行
        new_line = i.split()                  #以空格生成列表
        #isurl = new_line[9].find('.')
        if new_line[0] != '-':                #第一个元素不为空
             if new_line[5][1:-3] == LastMinute and new_line[7] == MatchRecord:    #匹配记录
                 record_list.append(float(new_line[0]))    #追加到列表

if __name__ == "__main__":
    record_list = []
    HandleData(50000)
    # print record_list
    # print len(record_list)
    # print sum(record_list)
    if len(record_list) > 6:
        record_list.sort()                 #列表排序
        record_list =  record_list[2:-2]   #去除两个最大值和最小值
    # print len(record_list)
        request_avg =  sum(record_list)/len(record_list)   #总数除以数量
        request_avg_2 = float('%0.2f'%request_avg)         #取小数点后两位
        print request_avg_2
    else:
        print 0
