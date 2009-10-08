

(defparameter *number-table* '(1 5 6 7))
(defparameter *func-table* '(+ - * /))
(defparameter answer 21)

(defun perm (l)
  (if (null l) '(())
      (mapcan #'(lambda (x)
                  (mapcar #'(lambda (y) (cons x y))
                          (perm (remove x l :count 1)))) l)))

(map nil
     #'(lambda (seq)
         (multiple-value-bind (a b c d)
             (apply #'values seq)
           (dolist (f1 *func-table*)
             (dolist (f2 *func-table*)
               (dolist (f3 *func-table*)
                 (handler-case
                     (if (= (eval `(,f1 ,a (,f2 ,b (,f3 ,c ,d)))) answer)
                         (format t "~a~a(~a~a(~a~a~a)) = ~a~%" a f1 b f2 c f3 d answer))
                   (division-by-zero () 'pass)))))))
     (perm *number-table*))


#|

(mapcar
 #'(lambda (seq)
     (multiple-value-bind (a b c d)
         (apply #'values seq)
       (dolist (f1 *func-table*)
         (dolist (f2 *func-table*)
           (dolist (f3 *func-table*)
             (handler-case
                 (if (= (funcall f1 a (funcall f2 b (funcall f3 c d))) 21)
                     (format t "(~a ~a (~a ~a (~a ~a ~a)))~%" f1 a f2 b f3 c d))
               (division-by-zero () 'pass)))))))
 (perm *number-table*))


|#