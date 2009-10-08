#!c:/develop/python26/python.exe
#-*- encoding: utf-8 -*-


import sys
from optparse import OptionParser

usage = "usage: %prog [options] input-file [output-file]"
op = OptionParser(usage=usage)
#op = OptionParser()
op.add_option('-f', '--from-code',
              action='store', type='string', dest='from_code', default='mbcs',
              help='the encoding of the input. default = MBCS')
op.add_option('-t', '--to-code',
              action='store', type='string', dest='to_code', default='mbcs',
              help='the encoding of the output. default = MBCS')


def main():
    sys_argv = sys.argv
    if len(sys_argv) == 1:
        sys_argv.append('--help')
    
    options, args = op.parse_args(sys_argv[1:])

    infile = open(args[0], 'rb')
    contents = infile.read()
    infile.close()

    if len(args) == 1:
        outfile = sys.stdout
    else:
        outfile = open(args[1], 'wb')

    outfile.write(unicode(contents, options.from_code).encode(options.to_code))
    outfile.close()
    

if __name__ == '__main__':
    main()
