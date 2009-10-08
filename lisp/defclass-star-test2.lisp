;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-


#+sbcl
(defmacro asdf-require (pkg)
  `(require ,pkg))


(asdf-require :defclass-star)


(defclass*:defclass* person ()
  ((age 0)
   (name nil)))

(defclass*:defclass* student (person)
  ((school :yonsei)
   (grade 1)))


(defgeneric show-age (o))
(defgeneric show-name (o))
(defgeneric show-school (o))
(defgeneric show-grade (o))
(defgeneric do-run (o))

(defmethod show-age ((o person))
  (prc "age =" (age-of o)))

(defmethod show-name ((o person))
  (prc "name =" (name-of o)))

(defmethod show-name ((o student))
  (prc "이름은 " (name-of o))
  (incf (age-of o)))

(defmethod show-school ((o student))
  (prc "school =" (school-of o)))

(defmethod show-grade ((o student))
  (prc "grade =" (grade-of o)))

(defmethod do-run ((o person))
  (if (next-method-p)
      (call-next-method o))
  (show-name o)
  (show-age o))

(defmethod do-run ((o student))
  (if (next-method-p)
      (call-next-method o))
  (show-school o)
  (show-grade o))



(defvar p)

(setf p (make-instance 'person :age 10 :name :monpetit))

(do-run p)

(setf p (make-instance 'student :age 20 :name :hamas))

(do-run p)



;; vim: set ft=lisp

