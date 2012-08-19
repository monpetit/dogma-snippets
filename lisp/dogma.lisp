;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(in-package :cl-user)

(defpackage :dogma
  (:nicknames :dm)
  #+sbcl (:use :cl :sb-ext)
  #-sbcl (:use :cl)
  (:export
   #:range
   #:writeln
   #:sethash
   #:prt
   #:prc
   #:prtln
   #:prcln
   #:prt-stream
   #:prc-stream
   #:prtln-stream
   #:prcln-stream
   #:does
   #:foreach
   #:ppmx
   #:str))


(in-package :dogma)

(defun range (n)
  (if (> n 0)
      (loop for i from 0 to (- n 1) collect i)))

(defun writeln (n)
  (write n)
  (terpri)
  n)

(defmacro sethash (key val htable)
  `(setf (gethash ,key ,htable) ,val))
#|
(defun prtln (&rest args)
  (loop for x in args do
       (format t "~s~%" x)))

(defun prcln (&rest args)
  (loop for x in args do
       (princ x)
       (terpri)))
|#

(defun prtln (&rest args)
  (format t "~{~s~%~}" args))

(defun prcln (&rest args)
  (format t "~{~a~%~}" args))

(defun prt (&rest args)
  (format t "~{~s~^ ~}" args)
  (terpri))

(defun prc (&rest args)
  (format t "~{~a~^ ~}" args)
  (terpri))

(defun prtln-stream (stream &rest args)
  (format stream "~{~s~%~}" args))

(defun prcln-stream (stream &rest args)
  (format stream "~{~a~%~}" args))

(defun prt-stream (stream &rest args)
  (format stream "~{~s~^ ~}" args)
  (terpri stream))

(defun prc-stream (stream &rest args)
  (format stream "~{~a~^ ~}" args)
  (terpri stream))

#|
(defun prt (&rest args)
  (if (<= (length args) 1)
      (prtln args)
      (prtln (reduce #'(lambda (x y) (format nil "~s ~s" x y)) args))))

(defun prc (&rest args)
  (if (<= (length args) 1)
      (prcln args)
      (prcln (reduce #'(lambda (x y) (format nil "~a ~a" x y)) args))))
|#


#|
(defun list-flatten (ls)
  (let ((result nil))
    (labels ((flatten (seq)
               (dolist (n seq)
                 (if (listp n)
                     (flatten n)
                     (setf result (append result (list n)))))))
      (flatten ls))
    result))
|#

(defconstant zero 0)
(defconstant else t)

#|
(defun nth-element (n l)
  "Enable negative index number."
  (if (>= n zero)
      (nth n l)
      (let ((index (+ (list-length l) n)))
        (if (>= index zero)
            (nth index l)))))
|#


(defmacro does (n &rest body)
  `(loop repeat ,n do
     ,@body))
#|
[example]
(does 10
  (format t "~a~%" (fortune)))
|#

(defun foreach (&rest body)
  (apply #'map nil body))
#|
[example]
(setf var 100)
(for-each (lambda (x) (incf var x)) (range 10))
|#


(defun filter (&rest body)
  (apply #'remove-if-not body))

#|
(defmacro push-back (slice stack)
  `(progn
     (setf ,stack (append ,stack (list ,slice)))
     ,stack))

(defmacro pop-back (stack)
  `(let ((slice (car (last ,stack))))
     (setf ,stack (butlast ,stack))
     slice))
|#


(defmacro ppmx (form)
  "Pretty prints the macro expansion of FORM."
  `(let* ((exp1 (macroexpand-1 ',form))
          (exp (macroexpand exp1))
          (*print-circle* nil))
     (cond ((equal exp exp1)
            (format t "~&Macro expansion:")
            (pprint exp))
           (t (format t "~&First step of expansion:")
              (pprint exp1)
              (format t "~%~%Final expansion:")
              (pprint exp)))
     (format t "~%~%")
     (values)))

#|
(defun unique (sequence &key (test #'eq))
  (let ((result nil))
    (dolist (x sequence)
      (if (not (find x result :test test))
          (push-back x result)))
    result))
|#

(defun str (&rest more)
  (let ((len (length more)))
    (cond ((= len 0) "")
          ((= len 1) (format nil "~a" (car more)))
          (t (reduce #'(lambda (x y) (format nil "~a~a" x y)) more)))))

;;
;;
;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;;
;;

(in-package :cl-user)

#+allegro (defun quit () (exit))
#+allegro (setf tpl:*print-length* nil)
#+allegro (setf (stream-external-format *terminal-io*)
                (find-external-format :utf-8))

#+sbcl (defun exit () (quit))

#+clisp (setf custom:*clhs-root-default* "c:/Develop/clisp-2.48/HyperSpec-7-0/HyperSpec/")
#+clisp (setf custom:*impnotes-root-default* "c:/Develop/clisp-2.48/doc/impnotes.html")

#+clozure (setf ccl:*default-file-character-encoding* :utf-8)


;;; ASDF
#+clisp (load "c:/Develop/clisp-2.48/asdf/asdf")
#-clisp (require :asdf)

#-sbcl (pushnew #P"/home/monpetit/.sbcl/systems/" asdf:*central-registry* :test #'equal)

(defmacro asdf-require (pkg)
  `(asdf:oos 'asdf:load-op ,pkg))

(defmacro asdf-test (pkg)
  `(asdf:oos 'asdf:test-op ,pkg))

#+win32
(defun refresh-asdf-registry ()
  (mapcar #'(lambda (dir)
              (pushnew dir asdf:*central-registry* :test #'equal))
          #+clisp (directory "c:/Develop/sbcl/site-systems/*/")
	  #+abcl (directory "c:/develop/sbcl/site-systems/*")
          #+clozure (directory "c:/Develop/sbcl/site-systems/*/" :directories t)
          #+sbcl (directory
                  (merge-pathnames "site-systems/*/"
                                   (truename (posix-getenv "SBCL_HOME"))))
          #+allegro (directory "C:/Develop/libcl-2009-09-01-alpha/" :directories-are-files nil)
          ))

#+win32
(refresh-asdf-registry)

#|
(defmacro defn (fname &body body)
  `(progn
     (defun ,fname ,@body)
     (setf ,fname (symbol-function (quote ,fname)))))

(defmacro def (a b)
  `(if (or (eql (type-of ,b) (type-of #'(lambda (x) x)))
           (eql (type-of ,b) (type-of #'+)))
       (progn
         (setf ,a ,b)
         (defun ,a (&rest more)
           (apply ,a more)))
       (setf ,a ,b)))
|#


(defun imports (functions)
  (dogma:foreach #'import functions))


