;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(def newline ()
  (prt "\n"))


(def prc (obj)
  (let result obj   
    (prt obj)
    (newline)
    obj))


(= s "foo")
(= (s 0) #\m)
(prc s)

(prc "우리는, 빛이 없는 어둠 속에서도 찾을 수 있는 우리는...")

(= s "우리는 연인")
(prc s)

(= (s 2) #\도)
(prc s)
(newline)



(prc
  (let x 10
       (+ x (* x 2))))

(prc
  (with (x 3 y 4)
        (sqrt (+ (expt x 2) (expt y 2)))))


(def average (x y)
  (prn "my arguments were: " (list x y))
  (/ (+ x y) 2))

(average 10 23)


(do (prn '안녕)
    (prn (+ 10 300)))

(pr 'foo "bar")
(newline)

(prt 'hello "world")


(def xxx  z
  (apply prn z))


(xxx 'hello 'young 'boy)


