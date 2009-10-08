;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(defun main ()
  (princ '(Hello Vladimir))
  (terpri))

(main)


(let ((func (lambda (x)
              (dolist (i (range x))
                (prt i '안녕-블라디미르)))))
  (funcall func 10))


(defun our-copy-list (lst)
  (if (atom lst)
      lst
      (cons (car lst) (our-copy-list (cdr lst)))))

(defvar x)
(defvar y)

(setf x '(hello vladimir and ansi common lisp))
(setf y (our-copy-list x))
(princln
  x y
  (eq x y)
  (eql x y)
  (equal x y))

(prc
  (append '(가 나 다) '(라 마 바 사) '(아)))


(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))

(defun compr (elt n 1st)
  (if (null 1st)
      (list (n-elts elt n))
      (let ((next (car 1st)))
        (if (eql next elt)
            (compr elt (+ n 1) (cdr 1st))
            (cons (n-elts elt n)
                  (compr next 1 (cdr 1st)))))))

(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

(compress '(1 1 1 0 1 0 0 0 0 1))

(setf x '(1 2 2 3 4 4 4 4 0 0 0 0 1 1 1 0 0 4 5 5))

(println
  (compress x)
  x)


(let ((msg '(교과서 보다 쉬운 독학 국사)))
  (println
    (nth 2 msg)
    (nthcdr 2 msg)))


(defun our-nthcdr (n lst)
  (if (zerop n)
      lst
      (our-nthcdr (1- n) (cdr lst))))

(let ((msg '(7차 교육 과정 한국 근현대사 편)))
  (println
    msg
    (nth 3 msg)
    (our-nthcdr 3 msg)))

(println
  (mapcar #'(lambda (x) (+ x 10))
          (range 5))
  (mapcar #'list
          '(a b c d e)
          '(1 2 3 4))
  (maplist #'(lambda (x) x)
           (range 5)))


(defun our-copy-tree (tr)
  (if (atom tr)
      tr
      (cons (our-copy-tree (car tr))
            (our-copy-tree (cdr tr)))))


(let ((seq '(a b c (d e f) g (h i) j (k l (m n) (o (p q r)) s))))
  (princln
    seq
    (copy-tree seq)
    (our-copy-tree seq)))


(defun our-subst (new old tr)
  (if (eql tr old)
      new
      (if (atom tr)
          tr
          (cons (our-subst new old (car tr))
                (our-subst new old (cdr tr))))))

(let
    ((expression '(and (integerp x) (zerop (mod x 2)))))
  (println
    expression
    (substitute 'y 'x expression)
    (subst 'y 'x expression)
    (our-subst 'y 'x expression)))


(flet ((hello (x)
         (prt 'hello x)))
  (hello 'vladimir))

;; vim: set ft=lisp

