#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-
# vim: set ts=8 sts=4 sw=4 et:

class mylist(list):
    def removeAll (self, item):
        if item not in self:
            raise ValueError('%s not in list' % item)
        count = self.count(item)
        for i in range(count):
            self.remove(item)

def main():
    l = mylist(range(10))
    l.extend(range(10))
    print (l)

    l.removeAll(2)
    print (l)

    l.removeAll(100)
    print (l)


if __name__ == '__main__':
    main()
