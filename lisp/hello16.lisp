;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defparameter ht (make-hash-table))

(gethash 'color ht)

(sethash 'color 'red ht)
(prt ht)

(defparameter bugs (make-hash-table))
(push "키워드는 어디로 갔나?"
      (gethash 'our-member bugs))
(prt bugs)

(defparameter fruits (make-hash-table))
(setf (gethash 'apricot fruits) t)
(gethash 'apricot fruits)
(remhash 'apricot fruits)
(prt fruits)

(setf (gethash 'shape ht) 'spherical
      (gethash 'size ht) 'giant
      (gethash '이름 ht) '몽쁘띠)


(maphash #'(lambda (key value)
             (prc key "=" value))
         ht)
(prt ht)

(defparameter writers (make-hash-table :size 10 :test #'equal))
(prt writers)
(setf (gethash '(블라디미르 몽쁘띠 하마스키) writers) t)
(prt writers)
(maphash #'prt writers)


;;;;;;

(block head
  (prt "시작합니다.")
  (return-from head '아이디어)
  (prt "절대 도착할 수 없는 곳!"))


(block head
  (prc "또 시작합니다.")
  (prc "빠져나온 값은 = "
       (block body
         (loop for i from 0 to 3 do
              (princ i)
              (princ #\space)
              (prt 'hello)
              (when (= i 2)
                (prc "블럭에서 빠져나갑니다.")
                (return-from body i)))))
  (prc "마무리..."))


(let ((result (dolist (item '(a b c d e))
                (format t "~a " item)
                (and (eq item 'c)
                     (return 'done)))))
  (format t "~%빠져나온 값은 = ~a~%" result))


(defun foo ()
  (return-from foo 27))

(foo)


(destructuring-bind
      (x y . z) '(1 2 3 4 x)
  (prt x y z))
