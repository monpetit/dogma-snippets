#-*- encoding: utf-8 -*-
# for python 3.0

def main():
    instream = open('hakju.txt', mode='r', encoding='utf-8')
    outstream = open('out.txt', mode='w', encoding='utf-8')
    buffers = instream.readlines()

    lineno = 1
    for buf in buffers:
        print (lineno, ': ', buf[:-1], file=outstream)
        lineno += 1

    print ('Hello Vladimir 안녕')

    instream.close()
    outstream.close()


if __name__ == '__main__':
    main()
