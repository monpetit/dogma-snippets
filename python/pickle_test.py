#-*- encoding: utf-8 -*-
#-*- using Python 3 -*-

import pickle

filename = 'c:/work/python/pickle_out.txt'
txtfile = 'c:/backup/homework/py31/data/hanja-dict.txt'
def main():
    '''
    hanjadic = dict()
    text = open(txtfile, 'rt', encoding='utf-8')
    contents = text.readlines()
    text.close()

    for line in contents:
        key, v1, v2 = line.split(':')
        hanjadic[key] = (v1, v2.strip())

    print (len(hanjadic))
    #print (hanjadic)
    
    outfile = 'c:/work/python/hanja_____.txt'
    outf = open(outfile, 'wt', encoding='utf-8')
    print (hanjadic, file=outf)
    outf.close()

    outfile = open(filename, 'wb')
    pickle.dump(hanjadic, outfile)
    outfile.close()
    '''

    infile = open(filename, 'rb')
    hanjadic = pickle.load(infile)
    infile.close
    print (len(hanjadic))

    inf = open('hakju.txt', 'rt', encoding='utf-8')
    text = inf.readlines()
    text = filter(lambda x: len(x.strip()) > 0, text)
    inf.close()

    outf = open('out.txt', 'wt', encoding='utf-8')
    for line in text:
        for ch in line:
            try:
                han = hanjadic[ch][0]
            except KeyError:
                han = ch
            print (han, end='', file=outf)
    outf.close()

if __name__ == '__main__':
    main()
