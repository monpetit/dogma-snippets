
(import 'dm:prtln)
(import 'dm:prcln)
(import 'dm:range)

(apply #'prtln (range 10))
(prcln "=-=-=-=-=-=")
(apply #'prcln (range 20))

(apply #'dm:prt (range 1000))
(dm:prc "안녕" '블라디미르 '몽쁘디 2 3 -49 "간장")

(dm:prc)
