;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.



(setf *print-array* nil)


(defun showdots (lst)
  (labels ((gendots (seq)
             (if (null seq)
                 'nil
                 (list (car seq) #\. (gendots (cdr seq))))))
    (format t "~a~%" (gendots lst)))
  nil)


(mapcar #'(lambda (x)
            (format t "~a ---> " x)
            (showdots x))
        '((1 2 3)
          (a b c d e)
          (세상엔 내가 너무도 많아 당신의 쉴 곳 없네)))

(showdots '(1 2 3))
(showdots (range 7))


(let ((arr (make-array '(2 3) :initial-element nil)))
  (prt arr)
  (prt (aref arr 0 0))
  (setf (aref arr 0 0) 'hello)
  (prt arr))

(setf *print-array* t)

(let ((vec (make-array 4)))
  (prt vec)
  (setf vec (vector "1" 0 'help 'me))
  (prt vec)
  (prt (svref vec 0))
  (prt (svref vec 3)))




