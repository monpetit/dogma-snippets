#-*- coding: utf-8 -*-

def say_hello(name):
    print ('안녕 %s!' % name)


def f(double x):
    return x**2 - x


def integrate_f(double a, double b, int N):
    cdef int i
    cdef double s, dx
    s = 0
    dx = (b - a) / N
    for i in range(N):
        s += f(a + i * dx)
    return s * dx


if __name__ == '__main__':
    say_hello('블라디미르')
    print(integrate_f(3000000000000000000000000, 4000000000000000000000000000000000000000000000000000000, 100))


