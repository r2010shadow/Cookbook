#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import subprocess


def cpu():

    raw_cmd = 'cat /proc/cpuinfo'

    raw_data = {
        'cpu_model': "%s |grep 'model name' |head -1 " % raw_cmd,
        'cpu_count':  "%s |grep  'processor'|wc -l " % raw_cmd,
        'cpu_core_count': "%s |grep 'cpu cores' |awk -F: '{SUM +=$2} END {print SUM}'" % raw_cmd,
    }

    for key, cmd in raw_data.items():
        try:
            result = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
            raw_data[key] = result.stdout.read().decode().strip()
        except ValueError as e:
            print(e)
            raw_data[key] = ""

    data = {
        "cpu_count": raw_data["cpu_count"],
        "cpu_core_count": raw_data["cpu_core_count"]
        }

    cpu_model = raw_data["cpu_model"].split(":")

    if len(cpu_model) > 1:
        data["cpu_model"] = cpu_model[1].strip()
    else:
        data["cpu_model"] = ''


    for k,v in data.items():
    	    print(k + ': ' + v )

cpu()