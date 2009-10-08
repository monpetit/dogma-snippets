#-*- mode: python -*-
#-*- encoding: utf-8 -*-

def main():
    a = 'JAH ZQSU WDYHF DI OKGZDFDPX AGQF TKPXJHFX'
    b = 'THE MIND POWER OF GLAMOROUS HAIR CLUSTERS'
    c = {}

    for i in range(len(a)):
        c[a[i]] = b[i]

    print (c)

    msg = [
        'TGPXH XKHHW',
        'ZGBH YAHHKHU EHAQTKHX XYHFEH',
        'XPZZDS FGQS',
        'ZGOQTGK KDTBQSO'
    ]        

    for line in msg:
        for ch in line:
            try:
                print(c[ch], end='')
            except KeyError:
                print('[?]', end='')            
        print ('')
    

    a = 'abcdefghijklmnopqrstuvwxyz '
    b = 'bcdefghijklmnopqrstuvwxyza '
    code = {}

    for i in range(len(a)):
        code[b[i]] = a[i]

    msg = 'zpv dpvme usz up fybnjof ju'


    #msg = 'qfsibqt zpv tipvme qvti ju cvu tbwf uif hbnf gjstu'
    
    for ch in msg:
        print (code[ch], end='')

    print (a[0])
        
if __name__ == '__main__':
    main()


'''
green wig: The green wig is a mass of greasy green ringlets.  Attached to the elastic band at the 
back is a little hand-lettered cardboard tag, which reads: .

auburn wig: The auburn wig is short and balloon-shaped.  Attached to the elastic band at the back 
is a little hand-lettered cardboard tag, which reads: .

blond wig: The hair of the blond wig sticks straight out, as if it’s made of clumps of straw.  
Attached to the elastic band at the back is a little hand-lettered cardboard tag, which reads: 
.

black wig: The black wig is very long, and the curls are tangled.  Attached to the elastic band at 
the back is a little hand-lettered cardboard tag, which reads: .

Bonus Tip: Garments in Interactive Fiction can often be worn by using the WEAR or DON 
command.  When you no longer want to wear something, you can REMOVE it.

> x paper
On the piece of paper someone has written, in block capitals with a stubby pencil, the phrase 
“.” Below this is another phrase, which oddly 
enough is total gibberish: “.”
'''
