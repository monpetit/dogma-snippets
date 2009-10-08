;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-


#+sbcl (require :sqlite)
#-sbcl (asdf-require :sqlite)

(use-package :sqlite)

;;Connect to the sqlite database. :memory: is the temporary in-memory database
(defparameter *db* (connect "c:/backup/homework/py31/data/hanja-dict.sqdb"))

(let ((rows (execute-to-list *db* "select * from hanja_table limit 3")))
  (mapcar #'prt rows))


(let ((rows (execute-to-list *db* "select * from hanja_table where hanja = ?" "貞")))
  (mapcar #'prt rows))

(let ((rows (execute-to-list *db* "select * from hanja_table where pron = ?" "석")))
  (mapcar #'prt rows))


(disconnect *db*) ;;Disconnect



;; vim: set ft=lisp