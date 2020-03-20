#!/usr/bin/env python

# 最近重启之后网络设备总接收和发送的数据

from __future__ import print_function
from collections import namedtuple

def netdevs():
    with open('/proc/net/dev') as f:
        net_dump = f.readlines()

    device_data = {}
    data = namedtuple('data',['rx', 'tx'])
    for line in net_dump[2:]:
        line = line.split(':')
        if line[0].strip() != 'lo':
            device_data[line[0].strip()] = data(float(line[1].split()[0])/(1024.0 * 1024.0),float(line[1].split()[8])/(1024.0 * 1024.0))
    return device_data

if __name__ == '__main__':

    netdevs = netdevs()
    for dev in netdevs.keys():
        print('{0}: rx {1} MiB tx {2} MiB'.format(dev, netdevs[dev].rx, netdevs[dev].tx))
