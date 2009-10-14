#!r6rs

(import (rnrs))

(define [prt . arg]
  (for-each (lambda (x) (display x) (display #\space)) arg)
  (newline))

(define [hello name]
  (display `(hello ,name))
  (newline))

(hello 'monpetit)


(prt '(1 2 3 4 5))

(define x '(1 2 3 4 5))
(prt (list? x))

(define [recur n]
  (if (= n 0) '()
      (begin
        (prt n)
	(recur (- n 1)))))

(recur 10)

(prt "하늘이 푸릅니다.")
(prt '창문을)

;; (define seq (string-split "하늘이 푸릅니다. 창문을 열면 온 방에 하나 가득 가슴에 가득" #\space))
;; (map prt seq)

(define-syntax defn
  (syntax-rules ()
    ((_ fname args ...)
     (define fname (lambda args ...)))))
     
(defn func [n]
  (let loop ((i n))
    (if (> i 0)
        (begin
          (prt (* i i))
	  (loop (- i 1))))))

(func 100)

(defn func1 [x y]
  (prt (- x y)))

(func1 20 30)


(define 이름 '도그마)

(defn 함수 [인자]
  (for-each display `(안녕 #\space ,인자))
  (newline))

(for-each 함수 `(,이름 vladimir monpetit 교육학))


(let [(x "단원별 기출문제")]
  (prt (string-length x))
  (prt (string->list x))
  (apply prt (string->list x)))
