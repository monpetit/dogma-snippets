;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(defparameter *hanja-table* (make-hash-table))


(defun prepare-hanja-table ()
  (with-open-file (inbuf "c:/work/lisp/dbtest/hanja-table.tbl"
                         :direction :input
			 #-clisp :external-format #-clisp :utf-8)
    (do ((row (read inbuf nil 'eof)
              (read inbuf nil 'eof)))
        ((eq row 'eof) 'done)
      (let ((key (car row))
            (value (cdr row)))
        (setf (gethash key *hanja-table*) value)))))



(defun translate-hanja-data (infile outfile)
  (with-open-file (inbuf infile
                         :direction :input
                         #-clisp :external-format #-clisp :utf-8)
    (with-open-file (outbuf outfile
                            :direction :output
                            :if-exists :supersede
                            #-clisp :external-format #-clisp :utf-8)
      (do ((hanja (read-char inbuf nil 'eof)
                  (read-char inbuf nil 'eof)))
          ((eq hanja 'eof) 'done)
        (let ((ch (format nil "~a" hanja)))
          (princ (or (car (gethash (intern ch) *hanja-table*))
                     ch)
                 outbuf))))))



(prepare-hanja-table)

(translate-hanja-data "c:/work/lisp/dbtest/in.txt"
                      "c:/work/lisp/dbtest/out.txt")

;; vim: set ft=lisp

