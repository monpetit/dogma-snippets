;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

#+sbcl (require :sqlite)
#-sbcl (asdf-require :sqlite)

(use-package :sqlite)

(defparameter *db* (connect "c:/work/lisp/person.sqdb")) ;;Connect to the sqlite database. :memory: is the temporary in-memory database

(execute-non-query *db* "create table users (id integer primary key, user_name text not null, age integer null)") ;;Create the table

(defun insert-db (name age)
  (execute-non-query *db* "insert into users (user_name, age) values (?, ?)" name age))

(mapcar #'(lambda (person)
            (insert-db (car person) (cadr person)))
        '(("joe" 18)
          ("dvk" 22)
          ("qwe" 30)
          ("블라디미르" 40)
          ("에스에스" 40)))


(let ((rows (execute-to-list *db* "select * from users")))
  (mapcar #'prc rows))

(disconnect *db*) ;;Disconnect

