;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.


(defclass food () ())

(defmethod cook :before ((f food))
  (prc "A food is about to be cooked.")
  )

(defmethod cook :after ((f food))
  (prc "A food has been cooked.")
  )

(defclass pie (food)
  ((filling :accessor pie-filling :initarg :filling :initform 'apple))
  )

(defmethod cook ((p pie))
  (prc "Cooking a pie")
  (setf (pie-filling p) (list 'cooked (pie-filling p)))
  )

(defmethod cook :before ((p pie))
  (prc "A pie is about to be cooked.")
  )

(defmethod cook :after ((p pie))
  (prc "A pie has been cooked.")
  )

(defvar pie-1)
(setf pie-1 (make-instance 'pie :filling 'apple))
(cook pie-1)

