#!/usr/bin/env python3
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-
# vim: set ts=8 sts=4 sw=4 et:


import re, sys
from optparse import OptionParser

usage = "usage: %prog [options] pattern [files]"
op = OptionParser(usage=usage)
op.add_option('-i', '--ignore-case',
              action='store_true', dest='ignore_case', default=False,
              help='ignore case distinctions')


def grep(reobj, f, length):
    if f == sys.stdin:
        fd = f
    else:
        fd = open(f, mode='rt', encoding='mbcs')

    if length == 1: fname = ''
    else: fname = f + ':'

    try:
        lines = fd.readlines()
    except UnicodeEncodeError:
        pass

    for line in lines:
        if reobj.search(line):
            try:
                print('{0}{1}'.format(fname, line), end='')
            except UnicodeEncodeError:
                pass
    fd.close()


def main():
    sys_argv = sys.argv
    if len(sys_argv) == 1:
        sys_argv.append('--help')

    options, args = op.parse_args(sys_argv[1:])

    if len(args) == 0:
        sys_argv.append('--help')
        op.parse_args(sys_argv)
        sys.exit(1)

    pattern = args[0]
    flags = options.ignore_case and re.IGNORECASE or 0
    reobject = re.compile(pattern, flags=flags)
    files = (len(args) > 1) and args[1:] or (sys.stdin, )

    for f in files:
        grep(reobject, f, len(files))


if __name__ == '__main__':
    main()
