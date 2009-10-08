
(load "petit-object")

(use-package :pt)
(cl:import 'dm:prt)

(defvar p)
(setq p (make-instance 'petit-object))

(set-attr p :name 'monpetit)
(set-attr p :age 40)

(mapcar #'prt (dir-of p))


(defclass person (petit-object)
  ((age :initarg :age
        :initform 0
        :accessor age-of)))


(setq p (make-instance 'person))
(set-attr p :age 100)
(set-attr p :name '몽쁘띠)
(set-attr p :결혼 :했음)
(set-attr p :자식 2)
(prt (dir-of p))
