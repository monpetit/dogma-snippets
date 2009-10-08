(defvar *foo* 0)
(defun foo () (incf *foo*))

(prt *foo*)
(prt (process-wait "Incrementing *foo*" #'foo))
(prt *foo*)

;;(foo)
;;(prt *foo*)