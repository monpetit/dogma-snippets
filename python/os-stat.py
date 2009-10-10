#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-
# vim: set ts=8 sts=4 sw=4 et:

import os, time

def main():
    filedata = os.stat('list-remove-all.py')
    attrs = dir(filedata)
    for attr in attrs:
        if attr[0] != '_':
            print (attr, '=', getattr(filedata, attr))
    print ('')

    mtime = time.localtime(filedata.st_mtime)
    attrs = dir(mtime)
    for attr in attrs:
        if attr[0] != '_':
            print (attr, '=', getattr(mtime, attr))


if __name__ == '__main__':
    main()
