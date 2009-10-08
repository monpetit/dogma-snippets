;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defn fact (n)
      (if (= n 0) 1
          (* n (fact (1- n)))))


(mapcar #'prt
 (mapcar fact (range 20)))



(defn fact (n)
      (prt 'hello)
      (do ((i 0 (1+ i)))
          ((> i n) (terpri))
        (prt i)))

(mapcar fact '(1 2 3))

(def factorial fact)

(mapcar factorial
        (range 10))


(def xxx (lambda (x)
           (+ x 10)))

(prt
  (xxx 10)
  (funcall xxx 10)
  (apply xxx '(10)))

