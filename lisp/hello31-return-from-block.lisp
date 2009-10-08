;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(import 'dm:prc)

;(setf *err* (open "c:/tmp/error-out.txt" :direction :output :if-exists :supersede))
;(setf *error-output* *err*)

(defun foo ()
  (prc "Entering foo")
  (block a
    (prc "  Entering BLOCK")
    (bar #'(lambda () (prc "          Escape from BLOCK") (return-from a)))
    (prc "  Leaving BLOCK"))
  (prc "Leaving foo"))

(defun bar (fn)
  (prc "    Entering bar")
  (baz fn)
  (prc "    Leaving bar"))

(defun baz (fn)
  (prc "      Entering baz")
  (prc "        fn =" fn)
  (funcall fn)
  (prc "      Leaving baz"))

(foo)

