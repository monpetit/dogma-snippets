
(defclass moving-object () ())
(defclass graphics-object () ())

(defvar *jet* '(:altitude 0 :speed 0))

(defclass plane (moving-object graphics-object)
  ((altitude :initarg :altitude
             :initform 0
             :accessor altitude-of)
   (speed    :initform 0
             :accessor speed-of)))


(defun new-plane (&rest more)
  (apply #'make-instance (cons 'plane more)))


(describe (new-plane))
(describe (new-plane :altitude 10))
(describe (new-plane :altitude 20))
(setf p (new-plane))
(with-slots (altitude speed) p
  (setf altitude 200
        speed 5000))



(describe p)

