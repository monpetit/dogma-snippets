;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(unintern 'petit)
(unintern 'petit2)

(defun petit (sym lst)
  (if (<= (length lst) 1)
      lst
      (cons (car lst) (cons sym (petit sym (cdr lst))))))

(prc (petit '- (range 7)))

(defun petit2 (sbl lst)
  (labels ((petit2-aux (sym seq1 seq2)
             (if (<= (length seq2) 1)
                 (append seq1 seq2)
                 (petit2-aux sym (append seq1 (list (car seq2) sym)) (cdr seq2)))))
    (petit2-aux sbl nil lst)))

(prc (petit2 '- (range 7)))


(labels ((add10 (x) (+ x 10))
         (consa (x) (cons 'a x)))
  (consa (add10 3)))


(defun combine (&rest args)
  (labels ((combinder (x)
             (typecase x
               (number #'+)
               (list #'append)
               (t #'list))))
    (apply (combinder (car args)) args)))

(princln
  (combine 1 2 3)
  (combine '(1 2 3) '(4 5))
  (combine 'a 'b 'c))


(let ((counter zero))
  (defun stamp-counter ()
    (incf counter))
  (defun reset-counter ()
    (setf counter zero)))

(println
  (stamp-counter)
  (stamp-counter)
  (stamp-counter)
  (stamp-counter)
  (reset-counter)
  (stamp-counter)
  (stamp-counter))


(let ((seq '(4 9 16 25)))
  (apply #'list
         (mapcar #'round
                 (mapcar #'sqrt seq))))


(defmacro ntimes (n &body body)
  (let ((g (gensym))
        (h (gensym)))
    `(let ((,h ,n))
       (do ((,g 0 (1+ ,g)))
           ((>= ,g ,h))
         ,@body))))


(ntimes 5
  (prt '안녕)
  (prt '가나다라))

(ppmx (ntimes 3
        (prt 'hello)
        (prt 'monpetit)))



