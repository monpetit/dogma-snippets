#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- mode: python; py-indent-offset: 4 -*-
# vim: set ts=8 sts=4 sw=4 et:

run = lambda clz: [_ for _ in clz]

def main():
    students = {'dogma': 4, 'vladimir': 3, 'monpetit': 3, 'illich': 1, 'gorbi': 2}

    for key, value in students.items():
        print('{0}는 {1}학년입니다.'.format(key, value))


if __name__ == '__main__':
    main()
