
(imports '(dm:prt))

(unwind-protect
     (progn
       (ignore-errors
         (prt (/ 1 0)))
       (prt 'hello))
  (prt 'monpetit))


(multiple-value-bind (result error-code)
    (unwind-protect
         (ignore-errors
           (prt (/ 1 0)))
      (prt 'hello-vladimir))
  (prt '------------------)
  (prt result)
  (prt error-code (type-of error-code)))


(unwind-protect
     (ignore-errors
       (throw 'some-error nil))
  (prt 'my-home!))



(unwind-protect
     (ignore-errors
       (error "we make error!")
       (prt '(we never reach here)))
  (prt 'my-wife-and-daughters!))

