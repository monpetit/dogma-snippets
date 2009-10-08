;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.



(prt '(하늘이 푸릅니다))


(defn prt (&rest more)
      (if more
          (princ (reduce #'(lambda (x y) (format nil "~a ~a" x y))
                         more)))
      (terpri))




(prt '하늘이 '푸릅니다)

(apply prt (range 10))
(prt 'hello)

(let ((x (range 10)))
  (prt (nth-element 2 x)
       (nth-element -111 x)))


(loop repeat 10 do
     (prt 'hello))
