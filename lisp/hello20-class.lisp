
(defclass colored ()
  ((color  :accessor color
           :initarg :color
           :initform 'white)))

(defclass rectangle ()
  ((height :accessor height
           :initarg :height
           :initform 1)
   (width  :accessor width
           :initarg :width
           :initform 1)))


(defclass circle ()
  ((radius :accessor radius
           :initarg :radius
           :initform 1)
   (center :accessor center
           :initarg :center
           :initform (cons 0 0))))



(defgeneric area (x)
  (:method ((x rectangle))
    (* (height x)
       (width x)))
  (:method ((x circle))
    (* (expt (radius x) 2)
       pi)))

(let ((r (make-instance 'rectangle :height 2 :width 3))
      (c (make-instance 'circle :radius 10)))
  (describe r)
  (prt (area r))
  (describe c)
  (prt (area c)))




(defclass graphic (colored)
  ((visible :accessor visible
            :initarg :visible
            :initform t)))

(let ((g (make-instance 'graphic)))
  (describe g))

(defclass screen-circle (circle graphic)
  ((color :initform 'purple)))

(let ((c  (make-instance 'screen-circle
                         :visible nil
                         :radius 3)))
  (describe c)
  (setf (color c) 'red)
  (describe c))
