;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

#-abcl
(asdf-require :closer-mop)

(let ((err-code (multiple-value-bind (res err)
                    (ignore-errors
                      (dm:prt 'monpetit)
                      (/ 1 0))
                  (class-name (class-of err)))))
  (dm:prt err-code)
  (dm:prt (if (eql err-code 'division-by-zero)
           '(oh no division by zero accurred)
           '(and so on...))))

#-abcl
(let ((err-code (multiple-value-bind (res err)
                    (ignore-errors
                      (dm:prt 'monpetit)
                      (error "some error" 'myerror))
                  (describe err)
                  (mapcar #'(lambda (x) (dm:prt (closer-mop:slot-definition-name x)))
                          (closer-mop:class-slots (class-of err)))
                  ;;   (dm:prt (slot-value err 'system::$format-control))
                  ;;   (dm:prt (car (slot-value err 'system::$format-arguments)))
                  (class-name (class-of err)))))
  (dm:prt err-code)
  (dm:prt (if (eql err-code 'division-by-zero)
           '(oh no division by zero accurred)
           '(and so on...))))



(define-condition petit-error (simple-error error)
  ((message :reader message
            :initarg :message)
   (code :reader code
         :initarg :code))
  (:report (lambda (condition stream)
             (format stream "Petit Error Message: ~s." (message condition)))))

(defun petit-error (&key message code)
  (error 'petit-error :message message :code code))


(multiple-value-bind (result err)
    (ignore-errors
      (petit-error :message "진짜로 그냥 에러" :code 'some-monpetit-error))
  ;;      (error 'petit-error :message "그냥 에러" :code 'some-unknown-error))
  (dm:prt "result:" result)
  (dm:prt "error:" err)
  (describe err)
  (dm:prt (message err) (code err)))


(define-condition dogma-error (simple-error error)
  ((message :accessor message-of
            :initform nil
            :initarg :message)
   (code    :accessor code-of
            :initform nil
            :initarg :code)))

(defun dogma-error (&key message code)
  (error 'dogma-error :message message :code code))


(multiple-value-bind (result err)
    (ignore-errors
      (dogma-error "도그마 에러" 1 2 3))
  (describe err))



(dm:prt (handler-case
         (progn
           (dm:prt '(hander-case test start...))
           (dotimes (i 10)
             (dm:prt i 'hello 'monpetit)
             (if (> i 3)
                 (dogma-error :message "일부러 낸 에러..." :code :intended-error)))
           (dm:prt '(hander-case test end...)))
       (dogma-error (e)
         (dm:prt (message-of e))
         (code-of e)) ;; :dogma-error-occurred)
       (simple-error () :simple-error-occurred)
       (petit-error () :petit-error-occurred)
       (:no-error (_) :no-error-occurred)
       (t () :really-unknown-error-occurred)))


