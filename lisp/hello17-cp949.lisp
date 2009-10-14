
(defstruct a
  x y)

(defstruct (b (:include a))
  z)

(defgeneric grind (x)
  (:method ((x a))
    (+ (a-x x) (a-y x)))
  (:method ((x b))
    (+ (b-z x) (call-next-method)))
  (:method ((x number))
    x))


(defparameter i (make-a :x 1 :y 2))
(defparameter j (make-b :x 3 :y 4 :z 5))

(princln
  (grind i)
  (grind j)
  (grind 10))

(println
  (class-of 'a) 	;; #<Built-In-Class SYMBOL>
  (class-of "a") 	;; #<Built-In-Class STRING>
  (class-of 12) 	;; #<Built-In-Class INTEGER>
  (class-of '(a b)) 	;; #<Built-In-Class CONS>
  (class-of '#(a b c)) 	;; #<Built-In-Class VECTOR>
  )


(defclass person ()
  ((name :accessor name
         :initform 'bill
         :initarg :name)
   (age  :accessor age
         :initform 10
         :initarg :age)))

(let ((bill (make-instance 'person))
      (mary (make-instance 'person :name 'mary))
      (john (make-instance 'person :name 'john :age 20))
      (billy (make-instance 'person :age 4))
      (prt-person (lambda (p)
                    (format t "instance: ~a --- (name: ~a, age: ~a)~%" p (name p) (age p)))))
  (funcall prt-person bill)
  (funcall prt-person mary)
  (funcall prt-person john)
  (funcall prt-person billy))


(defparameter dogma (make-instance 'person :name 'monpetit :age 40))

(prt
  (slot-value dogma 'name)
  (name dogma)
  (slot-value dogma 'age)
  (age dogma))

(describe dogma)


(defclass teacher (person)
  ((subject :accessor subject
            :initarg :subject)))

(defparameter
    prof-nam (make-instance 'teacher
                            :name 'namssam
                            :age 54
                            :subject 'middle-age-korean-history))
(describe prof-nam)
(prt
  (name prof-nam)
  (age prof-nam)
  (subject prof-nam))

(defclass history-teacher (teacher)
  ((subject :initform 'history)))

(defparameter prof-song (make-instance 'history-teacher :name 'songssam :age 61))

(describe prof-song)
(prc
 (name prof-song)
 (age prof-song)
 (subject prof-song))


(defgeneric change-subject (teach new-subject)
  (:method ((teach teacher) (new-subject symbol))
    (setf (subject teach) new-subject))
  (:method ((teach teacher) (new-subject string))
    (setf (subject teach) (intern (string-upcase new-subject)))))


(change-subject prof-nam 'history-of-chosun)
(describe prof-nam)

(change-subject prof-song "history-of-english")
(describe prof-song)


;;;;;;;;;;;;;;;;
(dotimes (i 3)
  (prt '------------------------------------------------))


(defclass 음식 () ())

(defgeneric 요리 (재료))

(defmethod 요리 :before ((재료 음식))
  (format t "음식: ~a 요리 전~%" 재료))

(defmethod 요리 :after ((재료 음식))
  (format t "음식: ~a 요리 끝~%" 재료))

(defmethod 요리 ((재료 음식))
  (format t "              음식: ~a 요리 중~%" 재료))


(defmethod 요리 :around ((재료 음식))
  (prc "전체 요리 전")
  (let ((result (call-next-method)))
    (prc "전체 요리 끝")
    result))


(defclass 파이 (음식)
  ((과일 :accessor 과일
         :initarg :과일
         :initform '사과)))

(defmethod 요리 :before ((재료 파이))
  (format t "~a 파이 요리 전~%" (과일 재료)))

(defmethod 요리 :after ((재료 파이))
  (format t "~a 파이 요리 끝~%" (과일 재료)))

(defmethod 요리 :around ((재료 파이))
  (prc "---- 파이 요리 전")
  (let ((result (call-next-method)))
    (prc "--- 파이 요리 끝")
    result))


(defmethod 요리 ((재료 파이))
  (format t "~a 파이 요리 중!~%" (과일 재료))
  (call-next-method)
  (setf (과일 재료) (list '요리된 (과일 재료))))


(let ((사과파이 (make-instance '파이 :과일 '사과)))
  (describe 사과파이)
  (prt '------------------------------------------------)
  (요리 사과파이)
  (prt '------------------------------------------------)
  (describe 사과파이))


(dotimes (i 3)
  (prt '------------------------------------------------))

(let ((빈대떡 (make-instance '음식)))
  (describe 빈대떡)
  (요리 빈대떡)
  (describe 빈대떡))


(defparameter 호두파이 (make-instance '파이 :과일 '호두))
(describe 호두파이)
(dotimes (i 3)
  (요리 호두파이)
  (prt '=-=-=-=-=-=-=-=-=-=-=-=-))


#+allegro (use-package :clos)
#+sbcl (use-package :sb-mop)

(prt
  (#+abcl sys:generic-function-methods
   #+ecl clos:generic-function-methods
  #-(or abcl ecl) generic-function-methods #'요리))
