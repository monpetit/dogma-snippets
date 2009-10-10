#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-


class MyClass:
    @staticmethod
    def smeth():
        print('스태틱 메쏘드입니다.')

    @classmethod
    def cmeth(__self__):
        print('%s의 클래스 메쏘드입니다.' % __self__)

    def show(__self__):
        print('나야 나...')


def main():
    MyClass.smeth()
    MyClass.cmeth()

    c = MyClass()
    c.smeth()
    c.cmeth()
    c.show()


if __name__ == '__main__':
    main()


# vim: set ft=python ts=8 sts=4 sw=4 et:
