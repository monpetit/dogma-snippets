#-*- mode: python -*-
#-*- encoding: utf-8 -*-


from multiprocessing import Process

def foo():
    print 'hello'

p = Process(target=foo)
p.start()
