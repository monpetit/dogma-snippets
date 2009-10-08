;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(asdf-require :cffi)

(cffi:define-foreign-library pyext
    (:unix (:or "libpyext.so.0" "libpyext.so"))
  (t (:default "pyext")))

(cffi:use-foreign-library pyext)

(load "pyext")

;;; helper functions

(defun py-none? (ptr)
  (equal (format nil "~a" ptr) (format nil "~a" (py-none))))

(defun null-pointer? (ptr)
  (equal (format nil "~a" ptr) (format nil "~a" (null-pointer))))


(defun db-first (db)
  (let ((item (db-first-item db)))
    (if (not (null-pointer? item))
        (cons (tuple-key item) (tuple-value item)))))

(defun db-last (db)
  (let ((item (db-last-item db)))
    (if (not (null-pointer? item))
        (cons (tuple-key item) (tuple-value item)))))

(defun db-next (db)
  (let ((item (db-next-item db)))
    (if (not (null-pointer? item))
        (cons (tuple-key item) (tuple-value item)))))

(defun db-prev (db)
  (let ((item (db-prev-item db)))
    (if (not (null-pointer? item))
        (cons (tuple-key item) (tuple-value item)))))

(defun db-keys (db)
  (labels ((dbkeys (iterkeys result)
             (let ((next (iter-next iterkeys)))
               (if (not next) result
                   (dbkeys iterkeys (cons next result))))))
    (nreverse (dbkeys (db-iterkeys db) nil))))

(defun db-values (db)
  (labels ((dbvalues (itervalues result)
             (let ((next (iter-next itervalues)))
               (if (not next) result
                   (dbvalues itervalues (cons next result))))))
    (nreverse (dbvalues (db-itervalues db) nil))))

(defun db-items (db)
  (labels ((dbitems (iterkeys result)
             (let ((next (iter-next iterkeys)))
               (if (not next) result
                   (dbitems iterkeys (cons (cons next (db-get db next)) result))))))
    (nreverse (dbitems (db-iterkeys db) nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(py-init)

(defun run-test ()
  (ignore-errors
    (if (= (py-runstr "for i in range(3): print '안녕...', i") -1)
        (error "python does not opend."))
    )
    t
  )

#+clozure (process-run-function "wait..." #'run-test)
(run-test)
(terpri)
;; (prc "hello monpetit")

(defvar p)
(setf p (null-pointer))
(format t "~a~%" p)

(setf p (py-none))
(format t "~a~%" p)

(prt (bdb-module))

(prt (bdb-module))
(prt (null-pointer? (bdb-module)))

(defvar db)
(setf db (db-open "hello.db" "w"))
(if (null-pointer? db)
    (error "database open error!" 'db-open-error))
(prc "db first --->" (db-first db))

(prt db)

(prt (db-size db))

(if (= (db-store db "하늘이" "푸릅니다") -1)
    (error "DB write error!"))

(prt (db-store db "창문을" "열면"))
(db-sync db)

(prt (db-size db))

(prc "db first --->" (db-first db))
(prc "db first --->" (db-first db))
(prc "db next --->" (db-next db))
(prc "db next --->" (db-next db))
(prc "db next --->" (db-next db))
(prc "db prev --->" (db-prev db))

(prc "hello --->" (db-get db "hello"))
(prc "창문을 --->" (db-get db "창문을"))

(prt (has-key db "super"))
(prt (has-key db "하늘이"))

(prt (db-del db "hotdog"))
(prt (db-del db "하늘이"))
(db-sync db)

(prc "db last --->" (db-last db))

(prc "db size:" (db-size db))

(defparameter iter (db-iterkeys db))
(prc (iter-next iter))
(prc (iter-next iter))
(prc (iter-next iter))

(prt (db-keys db) (length (db-keys db)))
(prt (db-values db) (length (db-values db)))
(prt (db-items db) (length (db-items db)))

;; (db-clear db)
;; (db-sync db)
(prc "db size:" (db-size db))

(let ((keys (db-iterkeys db)))
  (do ((i (iter-next keys) (iter-next keys)))
      ((not i))
    (prc "iterator next key: " i)))


(setf db (db-close db))
(py-close)

;; vim: set ft=lisp






