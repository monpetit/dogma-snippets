;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-


(asdf-require :alexandria)
(in-package :alexandria)

(mapcar #'import '(dogma:range dogma:prt))

(clamp 10000 1 100)
(iota 10)
(iota 10 :start 20)

(ignore-errors
  (unwind-protect-case ()
      (progn
        (prt 'hello)
        (dotimes (i 10)
          (prt i 'monpetit)
          (if (>= i 3) (error "오류..."))
          (if (>= i 5) (return 42))))
    (:normal (prt '정상이네요))
    (:abort (prt '비정상이네요))
    (:always (prt '요건-언제나-실행됩니다))))


(let ((table (make-hash-table)))
  (dotimes (i 10)
    (setf (gethash i table) (random 100)))
  (prt table)
  (prt (hash-table-plist table))
  (prt (hash-table-alist table)))


(defparameter x (curry '+ 100))

(let ((fact (named-lambda fact (n)
              (if (> n 1)
                  (* n (fact (- n 1)))
                  n))))
  (dotimes (i 30)
    (prt i (funcall fact i))))


(let ((x (range 10)))
  (prt x)
  (setf x (plist-alist x))
  (prt x)
  (setf x (alist-plist x))
  (prt x))


(let ((circle (circular-list 1 2 3 4)))
  (dotimes (i 20)
    (format t "~a " (nth i circle))))
    