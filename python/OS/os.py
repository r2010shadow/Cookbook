#!/usr/bin/env python
# -*- coding:utf-8 -*-

import subprocess


def get_os_info():
    """
    获取操作系统信息
    :return:
    """
    distributor = subprocess.Popen("lsb_release -a|grep 'Distributor ID'",
                                   stdout=subprocess.PIPE, shell=True)
    distributor = distributor.stdout.read().decode().split(":")

    release = subprocess.Popen("lsb_release -a|grep 'Description'",
                               stdout=subprocess.PIPE, shell=True)

    release = release.stdout.read().decode().split(":")
    data_dic = {
        "os_distribution": distributor[1].strip() if len(distributor) > 1 else "",
        "os_release": release[1].strip() if len(release) > 1 else "",
        "os_type": "Linux",
    }

    for k,v in data_dic.items():
        print(k + ': ' + v)

get_os_info()