
(defparameter *err* (open "c:/tmp/error-out.txt" :direction :output :if-exists :supersede))
(setf *error-output* *err*)

(defpackage :hello4
  (:use :cl :dogma))

(in-package :hello4)

(defconstant zero 0)



(dotimes (i 10)
  (prt i))


(defun sum (n)
  (let ((result 0))
    (dotimes (i (+ n 1) result)
      (incf result i))))

(mapcar #'sum (range 11))


(defun addn (n)
  #'(lambda (x)
      (+ x n)))


(defparameter add10 (addn 10))

(funcall add10 30)

(mapcar #'(lambda (x)
            (prt (funcall add10 x)))
        (range 10))

(mapcar #'(lambda (x)
            (prt (funcall (addn 30) x)))
        (range 10))

(prt (mapcar (addn 30) (range 30)))


(prtln
  (eval (quote (+ 3 5)))
  (eval '(+ 3 4 5 6 7))
  (eval '(range 10))
  )

(prtln
  '(내 3 "아들들")
  '(the list (a b c) has 3 elements)
  (list '내 (+ 3 5) "아들들")
  )

(prcln
  '(내 3 "아들들")
  '(the list (a b c) has 3 elements)
  (list '내 (+ 3 5) "아들들")
  )


(prcln
  (list '(+ 1 2) (+ 1 2)))


(prcln
  (cons '내 '(사랑 외로운 사랑))
  (cons '매 (cons '란 (cons '국 (cons '죽 '())))))

(let ((msg '(내 속엔 내가 너무도 많아 당신의 쉴 곳 없네...)))
  (prtln
    (car msg)
    (cdr msg)
    (car (cdr (cdr (cdr msg))))
    (third msg)
    (fourth msg)
    ))


(prtln
  (listp nil)
  (listp '(1 2 3))
  (listp #(1 2 3))
  (listp 30)
  (null nil)
  (not nil))

(prt
  (if (listp '(블라디미르 몽쁘띠))
      (+ 1 2)
      (+ 3 4))
  (if (listp -5034)
      (+ 5 6)
      (+ 7 8))
  (if (listp nil)
      '(안녕 블라디미르))
  (if (listp #(1 2 3))
      '(안녕 블라디미르)))

(prc
  (and t 10)
  (or t 10 2)
  (and 0 100))

(defun our-third (seq)
  (car (cdr (cdr seq))))

(our-third (range 10))


(defun our-member (item lst)
  (if (null lst)
      lst
      (if (eql item (car lst))
          lst
          (our-member item (cdr lst)))))

(prtln
  (our-member 10 (range 15))
  (our-member -1 (range 100)))

(format t "~a + ~a = ~a.~%" 2 3 5)

(defun askem (msg)
  (format t "~a" msg)
  (read))

;;(format t "당신의 나이는 ~a 살이네요."
;;        (askem "당신의 나이는 몇 살입니까? "))

(let ((msg '(지울 수 없는 그리움)))
  (prt msg)
  (setf (car msg) '상상할)
  (prt msg))



(let ((lst '(a b c d e f g)))
  (prtln
    lst
    (remove 'd lst))
  (prt lst))



(defun show-squre (start end)
  (let ((square (lambda (x) (* x x))))
    (do ((i start (1+ i)))
        ((> i end)
         'done)
      (prt i (funcall square i)))))

(show-squre 2 5)


(defun show-sq2 (start end)
  (flet ((square (x) (* x x)))
    (do ((i start (1+ i)))
        ((> i end)
         'done)
      (prt i (square i)))))

(show-sq2 12 15)

(defun show-sq3 (end)
  (map nil
       #'(lambda (x)
           (prt x (* x x)))
       end))

(show-sq3 (range 10))


(defun show-sq4 (start end)
  (if (> start end)
      'don
      (progn
        (prt start (* start start))
        (show-sq4 (1+ start) end))))

(show-sq4 2 10)


(defun our-length (lst)
  (let ((len zero))
    (dolist (i lst)
      (incf len))
    len))

(defun array->list (seq)
  (coerce seq 'list))

(flet ((show (x)
         (prt x (our-length x))))
  (let ((seq1 (range 10))
        (seq2 (array->list "안녕 블라디미르")))
    (show seq1)
    (show seq2)))

(prtln
  (function +)
  (function sort)
  #'*
  #'write-line
  #'prt)

(prt
  ((lambda (x)
     (+ x 100))
   5)
  (funcall #'(lambda (x) (+ x 100)) 5))

(defun enigma (x)
  (and (not (null x))
       (or (null (car x))
           (enigma (cdr x)))))

(enigma (range 10))
(enigma '(a b n x 3 4 nil 5 6 9 y z))


;; (require 'asdf)
;; (prt
;;  asdf:*central-registry*)


(setf x '(1 2 3)
      y x)
(prt x y (eql x y))
(setf (car x) 'hello)
(prt x y (eql x y))


(setf x '(a b c)
      y (copy-list x))
(prt x y (eql x y))
(setf (car x) 'hello)
(prt x y (eql x y))


(foreach #'prc
  "내 속엔 내가 너무도 많아 당신의 쉴 곳 없네")
