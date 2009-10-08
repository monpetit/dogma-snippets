;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

;;#-allegro
(defun range (n)
  (if (> n 0)
      (loop for i from 0 to (- n 1) collect i)))

(defun writeln (n)
  (write n)
  (terpri)
  n)

(defmacro sethash (key val htable)
  `(setf (gethash ,key ,htable) ,val))

;; (defmacro print-ln (&rest args)
;;   `(dolist (x ,@args)
;;      (write x)
;;      (write-line "")))
;; (defun println (&rest args)
;;   (print-ln args))

;; (defun println (&rest args)
;;   (dolist (x args)
;;     (write x)
;;     (terpri)))

;; (defun println (&rest args)
;;   (loop for x in args do
;;        (write x)
;;        (terpri)
;;      collect x))

(defun println (&rest args)
  (let ((result (loop for x in args do
                     (write x)
                     (terpri)
                   collect x)))
    (if (> (length result) 1)
        result
        (car result))))

(defun princln (&rest args)
  (let ((result (loop for x in args do
                     (princ x)
                     (terpri)
                   collect x)))
    (if (> (length result) 1)
        result
        (car result))))

;; (defun prt (&rest args)
;;   (if (<= (list-length args) 1)
;;       (println (car args))
;;       (progn
;;         (dolist (x (butlast args))
;;           (write x)
;;           (write-string " "))
;;         (println (car (last args))))))

;; (defun prt (&rest args)
;;   (loop for x in args
;;      for index from 1
;;      do (if (> index 1)
;;             (format t " ~s" x)
;;             (format t "~s" x))
;;      do (if (= index (length args)) (terpri))
;;      collect x))

(defun prt (&rest args)
  (let ((result (loop for x in args
                   for index from 1
                   do (if (> index 1)
                          (format t " ~s" x)
                          (format t "~s" x))
                   do (if (= index (length args)) (terpri))
                   collect x)))
    (if (> (length result) 1)
        result
        (car result))))

(defun prc (&rest args)
  (let ((result (loop for x in args
                   for index from 1
                   do (if (> index 1)
                          (format t " ~a" x)
                          (format t "~a" x))
                   do (if (= index (length args)) (terpri))
                   collect x)))
    (if (> (length result) 1)
        result
        (car result))))


(defun list-flatten (ls)
  (let ((result nil))
    (labels ((flatten (seq)
               (dolist (n seq)
                 (if (listp n)
                     (flatten n)
                     (setf result (append result (list n)))))))
      (flatten ls))
    result))

(defconstant zero 0)
(defconstant else t)

(defun nth-element (n l)
  "Enable negative index number."
  (if (>= n zero)
      (nth n l)
      (let ((index (+ (list-length l) n)))
        (if (>= index zero)
            (nth index l)))))

;; (defmacro does (n &rest body)
;;   `(dotimes (__dummy_index__ ,n)
;;      ,@body))
(defmacro does (n &rest body)
  `(loop repeat ,n do
     ,@body))
;; [example]
;; (does 10
;;   (format t "~a~%" (fortune)))

(defun for-each (&rest body)
  (apply #'map nil body))

;; (defun for-each (&rest body)
;;   (apply #'mapcar body)
;;   nil)

;; (defmacro for-each (&body body)
;;   `(progn (mapcar ,@body)
;;           nil))
;; [example]
;; (setf var 100)
;; (for-each (lambda (x) (incf var x)) (range 10))


;;
;; TODO: refactoring with tail recursion to forbid stack overflow!
;;
;; (defun filter (func seq)
;;   (if (null seq)
;;       nil
;;       (if (funcall func (car seq))
;;           (cons (car seq) (filter func (cdr seq)))
;;           (filter func (cdr seq)))))
;; [example]
;; (filter #'(lambda (x) (> x 3)) (range 100))
;;
;; (defun filter (fn seq)
;;   (remove-if #'(lambda (x)
;;                  (not (funcall fn x)))
;;              seq))

(defun filter (&rest body)
  (apply #'remove-if-not body))


(defmacro push-back (slice stack)
  `(progn
     (setf ,stack (append ,stack (list ,slice)))
     ,stack))

(defmacro pop-back (stack)
  `(let ((slice (car (last ,stack))))
     (setf ,stack (butlast ,stack))
     slice))

#+sbcl
(defun list->array (l)
  (make-array (list-length l)
              :initial-contents l))

;; (defun array->list (seq)
;;   (let ((result nil))
;;     (do ((index 0 (1+ index)))
;;         ((= index (length seq)) result)
;;       (push-back (aref seq index) result))))

#-sbcl
(defun list->array (l)
  (coerce l 'array))

(defun array->list (seq)
  (coerce seq 'list))



;; #+clisp (defvar *lisp-dirs* "d:/develop/clisp-2.41/" "Root location of CL library installs")
;;  (load (concatenate 'string *lisp-dirs* "asdf/asdf.lisp")))

;;   #+allegro (dolist (dir-candidate (directory (concatenate 'string *lisp-dirs* "*")))
;;   	    (when (file-directory-p dir-candidate)
;;   	      (let ((asd-candidate (merge-pathnames "*.asd" (pathname-as-directory dir-candidate))))
;;   		(when (directory asd-candidate)
;;   		  (push (pathname-as-directory dir-candidate) asdf:*central-registry*)))))
;;   #+lispworks (dolist (dir-candidate (directory (concatenate 'string *lisp-dirs* "*")))
;;   	      (when (lw:file-directory-p dir-candidate)
;;   		(let ((asd-candidate (merge-pathnames "*.asd" dir-candidate)))
;;   		  (when (directory asd-candidate)
;;   		    (push dir-candidate asdf:*central-registry*)))))
;;   #+clisp (dolist (dir-candidate (directory (concatenate 'string *lisp-dirs* "*/")))
;;   	  (let ((asd-candidate (merge-pathnames "*.asd" dir-candidate)))
;;   	    (when (directory asd-candidate)
;;   	      (push dir-candidate asdf:*central-registry*))))



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


(defun unique (sequence &key (test #'eq))
  (let ((result nil))
    (dolist (x sequence)
      (if (not (find x result :test test))
          (push-back x result)))
    result))

#-allegro
(defmacro while (test &body body)
  `(do ()
       ((not ,test))
     ,@body))


#+clisp (defvar *lisp-dirs* "d:/develop/clisp/" "Root location of CL library installs")
;; #+clisp (setf *default-pathname-defaults* (pathname *lisp-dirs*))

#+clisp (push #p"d:/develop/clisp/**/" *load-paths*)
#+clisp (push #p"d:/develop/clisp/asdf-registry/**/" *load-paths*)

;;#+clisp (require 'asdf)
;;#+clisp (push #p"d:/develop/clisp/asdf-registry/split-sequence" asdf:*central-registry*)
;;#+clisp (push #p"d:/develop/clisp/asdf-registry/cffi_0.9.1" asdf:*central-registry*)




#+allegro (defun quit () (exit))
#+allegro (setf tpl:*print-length* nil)
#+allegro (setf (stream-external-format *terminal-io*)
                (find-external-format :utf-8))


#+sbcl (defun exit () (quit))

;;
;; queue utils
;;
(defmacro queue-push (element queue)
  `(push-back ,element ,queue))

(defmacro queue-pop (queue)
  `(pop ,queue))

(defun queue-front (queue)
  (first queue))

(defun queue-back (queue)
  (car (last queue)))

(defun queue-empty (queue)
  (null queue))


#+sbcl (require 'asdf)
;; #+sbcl (pushnew #p"d:/develop/sbcl/lib/sbcl/site/*/" asdf:*central-registry*)
#+sbcl (pushnew #p"d:/develop/sbcl/lib/sbcl/site/cffi_0.9.2/" asdf:*central-registry*)
#+sbcl (pushnew #p"d:/develop/sbcl/lib/sbcl/site/rt-20040621/" asdf:*central-registry*)
#+sbcl (pushnew #p"d:/develop/sbcl/lib/sbcl/site/cl-ppcre-1.2.18/" asdf:*central-registry*)
#+sbcl (pushnew #p"d:/develop/sbcl/lib/sbcl/site/split-sequence/" asdf:*central-registry*)



#+clisp (setf custom:*clhs-root-default* "c:/Develop/clisp-2.48/HyperSpec-7-0/HyperSpec/")
#+clisp (setf custom:*impnotes-root-default* "c:/Develop/clisp-2.48/doc/impnotes.html")


(defun str+ (&rest seq) (apply #'concatenate (cons 'string seq)))

