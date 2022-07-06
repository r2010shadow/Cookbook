# -*- coding:utf-8 -*-

import os

Params = {
    'server' : '10.20.20.63',
    'port': 8000,
    'url': '/assets/report/',
    'request_timeout': 30,
}


PATH = os.path.join(os.path.dirname(os.getcwd()), 'log', 'cmdb.log')