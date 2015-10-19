#!/usr/bin/python2
# -*- coding: utf-8 -*-

import sys

for line in sys.stdin:
    for i in line.split():
        print " ".join(
            (str(len(i)), i)
        )
