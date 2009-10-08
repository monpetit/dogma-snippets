#-*- mode: python -*-
#-*- encoding: utf-8 -*-

import locale
def main():
    print (locale.getdefaultlocale())
    locale.setlocale(locale.LC_ALL, locale.getdefaultlocale())

    print (locale.getlocale(locale.LC_ALL))
    print (locale.getpreferredencoding())


if __name__ == '__main__':
    main()
