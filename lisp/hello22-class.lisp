;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defclass speaker () ())

(defgeneric speak (s msg))

(defmethod speak ((s speaker) msg)
  (princ msg))

(defmethod speak :before ((s speaker) msg)
  (princ "I think "))

(defclass intellectual (speaker) ())

(defmethod speak :before ((s intellectual) msg)
  (princ "Perhaps "))

(defmethod speak :after ((s intellectual) msg)
  (princ " in some sense."))


(speak (make-instance 'intellectual) "I'm hungry")


(defclass courtier (speaker) ())

(defmethod speak :around ((s courtier) msg)
  (format t "Does the King believe that ~a? " msg)
  (if (eql (read) 'yes)
      (if (next-method-p) (call-next-method))
      (format t "Indeed, it is a preposterous idea"))
  (prc ".")
  'bow)


(defun test-courtier ()
  (speak (make-instance 'courtier) "kings will last"))


;;
;;

(defgeneric price (x)
  (:method-combination +))

(defclass jacket ()
  ((jk-price :accessor jacket-price
             :initarg :jacket-price
             :initform 0)))

(defclass trousers ()
  ((tr-price :accessor trousers-price
             :initarg :trousers-price
             :initform 0)))

(defclass suit (jacket trousers) ())


(defmethod price + ((jk jacket))
           (jacket-price jk))

(defmethod price + ((tr trousers))
           (trousers-price tr))


(let ((s (make-instance 'suit
                        :trousers-price 450
                        :jacket-price 360)))
  (describe s)
  (prt (price s)))

(let ((jk (make-instance 'jacket :jacket-price 120))
      (tr (make-instance 'trousers :trousers-price 340))
      (st (make-instance 'suit :jacket-price 230 :trousers-price 510)))
  (mapcar #'(lambda (x)
              (prt x (price x)))
          (list jk tr st)))


