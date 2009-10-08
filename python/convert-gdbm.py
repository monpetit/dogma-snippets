#-*- coding: utf-8 -*-
# python 2.6

import bsddb, gdbm

indb = bsddb.hashopen('hanja-dict.db', 'r')
odb = gdbm.open('hanja-dict.gdb', 'c')

print (len(indb))
for key, value in indb.items():
	odb[key] = value

indb.close()
odb.close()