
(asdf-require :lift)

(lift:deftestsuite bdb-test () ())

(lift:addtest (bdb-test)
  (lift:ensure-same "hello" (format nil "~a" 'hello)))

(lift:addtest (bdb-test)
  (lift:ensure-same (/ 1 10) 0))

;; (lift:run-tests)
(describe (lift:run-tests))




(lift:deftestsuite petit-test () ())

(lift:addtest (petit-test)
  (lift:ensure-same 'hello (car '(hello monpetit))))

(lift:addtest (petit-test)
  (lift:ensure-same (/ 0 10) 0))

(lift:addtest (petit-test)
  (lift:ensure-error (error "some error!")))

(lift:addtest (petit-test)
  (lift:ensure-error (/ 1 0)))

(lift:addtest (petit-test)
  (lift:ensure-error (= 3 (+ 1 2))))

(lift:addtest (petit-test)
  (lift:ensure-error (+ 3 (+ 1 2))))

;; (lift:run-tests)
(describe (lift:run-tests))
