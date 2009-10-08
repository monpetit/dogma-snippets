
(call/cc
 (define (find-it n)
   (call/cc (lambda (break)
              (do ((i 0 (+ i 1)))
                  ((> i 100) #f)
                (prt i)
                (and (= i n) (break i))))))

(define (search x)
  (let ((n (find-it x)))
    (or
     (and n (prt 'ok! 'n 'is n))
     (prt 'ooops! 'not 'found))))

(search 100)
(search 20)
(search -3)
(search 3000)
(search 70)
