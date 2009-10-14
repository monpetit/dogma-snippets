
(defpackage :petit-object
  (:use :common-lisp :cl-user)
  (:nicknames :pt)
  (:export #:petit-object
           #:has-attr?
           #:set-attr
           #:get-attr
           #:del-attr
           #:dir-of))

(in-package :petit-object)


(defclass petit-object ()
  ((data :accessor data-of
         :initarg :data
         :initform (make-hash-table))))


(defgeneric has-attr? (inst key)
  (:method ((inst petit-object) key)
    (multiple-value-bind (_ has-key-p)
        (gethash key (data-of inst))
      has-key-p)))

(defgeneric set-attr (inst key value)
  (:method ((inst petit-object) key value)
    (setf (gethash key (data-of inst)) value)))

(defgeneric get-attr (inst key)
  (:method ((inst petit-object) key)
    (gethash key (data-of inst))))

(defgeneric del-attr (inst key)
  (:method ((inst petit-object) key)
    (remhash key (data-of inst))))

(defgeneric dir-of (inst)
  (:method ((inst petit-object))
    (let ((attributes nil))
      (maphash #'(lambda (key value)
                   (push (cons key value) attributes))
               (data-of inst))
      attributes)))

(when nil
  (defvar p)

  (setf p (make-instance 'petit-object))
  (describe p)
  (data-of p)

  (prt
    (has-attr? p 'name))

  (set-attr p :name 'monpetit)
  (set-attr p :age 30)
  (set-attr p :sex 'man)
  (set-attr p :school 'yonsei)
  (set-attr p :grade 4)

  (prt (get-attr p :age))
  (del-attr p :age)

  (prt (dir p))
)
;; (in-package :cl-user)
