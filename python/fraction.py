#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-
# vim: set ts=8 sts=4 sw=4 et:

from fractions import Fraction

def main():
    x = Fraction(1, 3)
    print ('x =', x)
    x = x * 7
    print ('x =', x)

    y = Fraction(10, 5)
    print ('y =', y)
    try:
        y = y / Faction(0, 1)
    except:
        pass
    print ('y =', y, ',\ttype of y =', type(y))    
    if y == 2:
        print ('y == 2')
    else:
        print ('y != 2')

if __name__ == '__main__':
    main()
