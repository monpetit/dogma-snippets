#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-
# vim: set ts=8 sts=4 sw=4 et:

import os, glob

run = lambda clz: [_ for _ in clz]

def main():
    pyfiles = glob.glob('*.py')
    run(map(print, map(os.path.realpath, pyfiles)))
    print('=-=-=-=-=-=-=-=-=-=')

    run(map(print, [f for f in pyfiles if os.stat(f).st_size > 1000]))


if __name__ == '__main__':
    main()
