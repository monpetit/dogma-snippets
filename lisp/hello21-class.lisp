(imports '(dogma:prt dogma:prc))

(let ((counter 0))
  (defun stamp-counter ()
    (incf counter))
  (defun reset-counter ()
    (setf counter 0)))


(defclass 생물 ()
  ((alive :accessor alive
          :initarg :alive
          :initform t)
   (birth :accessor birth
          :initarg :birth
          :initform nil)))

(defclass 성별 (생물)
  ((sex  :accessor sex
         :initarg :sex
         :initform '알수없음)))

(defclass 사람 (생물)
  ((name :accessor name
         :initarg :name
         :initform '무명)
   (age  :accessor age
         :initarg :age
         :initform 1)))

(defclass 학생 (사람 성별)
  ((grade :accessor grade
          :initarg :grade
          :initform '초등)))

(defgeneric reset-object (x))

(defmethod reset-object ((x 생물))
  (prc "생물 counter =" (stamp-counter))
  (setf (birth x) nil)
  (setf (alive x) t))

(defmethod reset-object :before ((x 생물))
  (prc "생물 rest 전 counter =" (stamp-counter)))

(defmethod reset-object :after ((x 생물))
  (prc "생물 rest 후 counter =" (stamp-counter)))

(defmethod reset-object :around ((x 생물))
  (prc "생물 rest 주변 전 counter =" (stamp-counter))
  (let ((result (call-next-method)))
    (prc "생물 rest 주변 후 counter =" (stamp-counter))
    result))


(defmethod reset-object ((x 사람))
  (prc "사람 counter =" (stamp-counter))
  (setf (name x) '무명)
  (setf (age x) 1)
  (call-next-method))

(defmethod reset-object :before ((x 사람))
  (prc "사람 rest 전 counter =" (stamp-counter)))

(defmethod reset-object :after ((x 사람))
  (prc "사람 rest 후 counter =" (stamp-counter)))

(defmethod reset-object :around ((x 사람))
  (prc "사람 rest 주변 전 counter =" (stamp-counter))
  (let ((result (call-next-method)))
    (prc "사람 rest 주변 후 counter =" (stamp-counter))
    result))


(defmethod reset-object ((x 성별))
  (prc "성별 counter =" (stamp-counter))
  (setf (sex x) '알수없음)
  (call-next-method))


(defmethod reset-object :before ((x 성별))
  (prc "성별 rest 전 counter =" (stamp-counter)))

(defmethod reset-object :after ((x 성별))
  (prc "성별 rest 후 counter =" (stamp-counter)))

(defmethod reset-object :around ((x 성별))
  (prc "성별 rest 주변 전 counter =" (stamp-counter))
  (let ((result (call-next-method)))
    (prc "성별 rest 주변 후 counter =" (stamp-counter))
    result))


(defmethod reset-object ((x 학생))
  (prc "학생 counter =" (stamp-counter))
  (setf (grade x) '초등)
  (call-next-method))

(defmethod reset-object :before ((x 학생))
  (prc "학생 rest 전 counter =" (stamp-counter)))

(defmethod reset-object :after ((x 학생))
  (prc "학생 rest 후 counter =" (stamp-counter)))

(defmethod reset-object :around ((x 학생))
  (prc "학생 rest 주변 전 counter =" (stamp-counter))
  (let ((result (call-next-method)))
    (prc "학생 rest 주변 후 counter =" (stamp-counter))
    result))




(defun test ()
  (let ((s (make-instance '학생
                          :birth '(1980 11 23)
                          :name '도그마
                          :age 23
                          :grade '대학
                          :sex '남자))
        (hline (lambda () (prt '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=))))
    (describe s)
    (funcall hline)

    (setf (birth s) '(1970 9 9)
          (age s) 39
          (grade s) '대학원
          (alive s) nil)

    (describe s)
    (funcall hline)

    (reset-object s)
    (describe s)

    (reset-counter)
    (funcall hline)))

(test)


(asdf-require :closer-mop)
(mapcar #'prt (closer-mop:generic-function-methods #'reset-object))