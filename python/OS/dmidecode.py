#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import subprocess


def collect():
    filter_keys = ['Manufacturer', 'Serial Number', 'Product Name', 'UUID', 'Wake-up Type']
    raw_data = {}

    for key in filter_keys:
        try:
            res = subprocess.Popen("sudo dmidecode -t system|grep '%s'" % key,
                                   stdout=subprocess.PIPE, shell=True)
            result = res.stdout.read().decode()
            data_list = result.split(':')

            if len(data_list) > 1:
                raw_data[key] = data_list[1].strip()
            else:
                raw_data[key] = ''
        except Exception as e:
            print(e)
            raw_data[key] = ''

    data = dict()
    data['asset_type'] = 'server'
    data['manufacturer'] = raw_data['Manufacturer']
    data['sn'] = raw_data['Serial Number']
    data['model'] = raw_data['Product Name']
    data['uuid'] = raw_data['UUID']
    data['wake_up_type'] = raw_data['Wake-up Type']

    for k,v in data.items():
        print(k + ': ' + v )

collect()