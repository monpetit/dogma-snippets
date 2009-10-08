#-*- coding: utf-8 -*-

import time

def main():
    start = time.time()
    result = reduce (lambda x, y: x*y, range (1, 100001))
    end = time.time()
    print ('%f s' % (end-start))


    sum = 1
    i = 1
    start = time.time()
    while i <= 100000:
        sum *= i
        i += 1
    end = time.time()
    print ('%f s' % (end-start))        

if __name__ == '__main__':
    main()
