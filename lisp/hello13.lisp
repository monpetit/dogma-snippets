;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(mapcar #'println
        '(하늘 다람쥐 가을 높이 올라라))
(setf x 10)
(prt x)

(let ((x 20))
  (prt x))
(prt x)

(block nil
  (let ((x 0))
    (incf x)
    (prt x)
    (return)
    (prt x)))


(block nil
  (let ()
    (incf x)
    (prt x)
    (return)
    (loo for i from 0 to 10
         do (prt i))))


(defparameter *name* 'monpetit)

(let ((name *name*))
  (prt name)
  (setf name 'vladimir)
  (prt name))


(defparameter *my-symbol* "단원별 기출문제")

(let ((sym *my-symbol*))
  (prt sym)
  (setf sym "5지선다 재구성")
  (prt sym))

(prt *my-symbol*)