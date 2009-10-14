
(defclass point ()
  (x y z))

(defparameter my-point (make-instance 'point))


(defun set-point-values (point x y z)
  (setf (slot-value point 'x) x
        (slot-value point 'y) y
        (slot-value point 'z) z)
  point)

(set-point-values my-point 10 20 30)

(defun distance-from-origin (point)
  (with-slots (x y z)
      point
    (sqrt (+ (* x x) (* y y) (* z z)))))

(prt (distance-from-origin my-point))

(prt (find-class 'point))

(prt my-point)


(defvar counter-inc)
(defvar counter-reset)

(setf counter-inc (let ((counter zero))
                    (lambda ()
                      (incf counter))))

(dotimes (i 10)
  (prt (funcall counter-inc)))


(defvar list-of-funcs
  (let ((counter zero))
    (cons (lambda ()
            (incf counter))
          (lambda ()
            (setf counter zero)))))

(setf counter-inc (car list-of-funcs)
      counter-reset (cdr list-of-funcs))

(dotimes (i 20)
  (prt (or (and (zerop (mod i 7))
                (funcall counter-reset))
           (funcall counter-inc))))
