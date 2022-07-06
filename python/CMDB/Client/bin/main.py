#!/usr/bin/env python
# -*- coding:utf-8 -*-

"""
完全可以把客户端信息收集脚本做成windows和linux两个不同的版本。
"""
import os
import sys


BASE_DIR = os.path.dirname(os.getcwd())
sys.path.append(BASE_DIR)

from core import handler

if __name__ == '__main__':

    handler.ArgvHandler(sys.argv)