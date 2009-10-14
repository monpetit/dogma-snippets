
(asdf-require :defclass-star)
(asdf-require :closer-mop)

(import 'dogma:prt)
(import 'dogma:prtln)

(defclass*:defclass* person ()
  (name age sex))

(defparameter w (make-instance
                 'person
                 :name '도그마
                 :age 23
                 :sex '남))

(with-slots (name age sex) w
  (prt '이름 name)
  (prt '나이 age)
  (prt '성별 sex))



(defclass*:defclass* student (person)
  (school grade))


(let ((person (find-class 'person)))
  (prtln
    (closer-mop:class-slots person)
    (closer-mop:class-direct-superclasses person)
    (closer-mop:class-direct-slots person)
    (closer-mop:class-direct-default-initargs person)
    (closer-mop:class-precedence-list person)
    (closer-mop:class-direct-subclasses person)
    (closer-mop:class-finalized-p person)
    (closer-mop:class-prototype person)
))


(let ((student (find-class 'student)))
  (prtln
    (closer-mop:class-slots student)
    (closer-mop:class-direct-superclasses student)
    (closer-mop:class-direct-slots student)
    (closer-mop:class-direct-default-initargs student)
    (closer-mop:class-precedence-list student)
    (closer-mop:class-direct-subclasses student)
    (closer-mop:class-finalized-p student)
    (closer-mop:class-prototype student)
))




(defclass counter ()
  ((count :allocation :class
          :initform 0
          :reader how-many
          :accessor count-of)))

;;(defgeneric initialize-instance (obj &rest args))

(defmethod initialize-instance :after ((obj counter) &rest args)
  (incf (count-of obj)))

(defclass counted-object (counter)
  ((name :initarg :name
         :accessor name)))

(defparameter o (make-instance 'counted-object :name 'monpetit))
(prt (how-many (closer-mop:class-prototype (find-class 'counter))))
(setf o (make-instance 'counted-object :name 'hello-monpetit))
(prt (how-many (closer-mop:class-prototype (find-class 'counter))))



(let ((counted-object (find-class 'counted-object)))
  (prtln
    (closer-mop:class-slots counted-object)
    (closer-mop:class-direct-superclasses counted-object)
    (closer-mop:class-direct-slots counted-object)
    (closer-mop:class-direct-default-initargs counted-object)
    (closer-mop:class-precedence-list counted-object)
    (closer-mop:class-direct-subclasses counted-object)
    (closer-mop:class-finalized-p counted-object)
    (closer-mop:class-prototype counted-object)
    (closer-mop:compute-class-precedence-list counted-object)
))
