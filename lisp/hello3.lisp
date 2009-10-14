
(println
  (symbol-name 'vladimir)
  (symbol-name '가나다)
  (symbol-name '|서원 대학교 역사 교육과|)
  )


(princln
  (package-name *package*)
  (find-package "COMMON-LISP-USER")
  (find-package "CL-USER"))

(defvar sym)
(setf sym 99)

(setf *package* (make-package
                 'mine
                 :use '(common-lisp)))

(in-package :cl-user)
(loop for i from 0 to 100
     do (prt 'hello-vladimir i))

(in-package :mine)
(cl-user::prt '(hello monpetit))
