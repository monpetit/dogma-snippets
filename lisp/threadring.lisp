;;; The Computer Language Benchmarks Game
;;; http://shootout.alioth.debian.org/
;;;
;;; contributed by Witali Kusnezow 2008-12-19
;;;     using semaphore synchronization

(defconstant  +threads+ 503)
(defparameter *counter* 0)
(defparameter *current* 0)
(defparameter *semaphore* (sb-thread:make-semaphore))
(defparameter *semaphores*
  (make-array +threads+
              :initial-contents
              (loop for i of-type fixnum below +threads+
                 collect (sb-thread:make-semaphore))))

(declaim (type fixnum *counter* *current*))

(defmacro wait   (semaphore)
  `(sb-thread:wait-on-semaphore ,semaphore))
(defmacro wake (semaphore)
  `(sb-thread:signal-semaphore  ,semaphore))
(defmacro kill   (thread)
  `(handler-case (sb-thread:terminate-thread ,thread)
     (sb-thread:interrupt-thread-error () nil)))

(defun thread-body ()
  (let* ((curr (svref *semaphores* *current*))
         (next (svref *semaphores* (if (= (incf *current*) +threads+) 0 *current*)))
         (number *current*))
    (loop do (wait curr)
       until (zerop (decf *counter*))
       do (wake next)
       finally (format t "~d~%" number) (wake *semaphore*))))

(defun start (n)
  (declare (type fixnum n))
  (setq *counter* (1+ n) *current* 0)
  (loop for i of-type fixnum below +threads+
     collect (sb-thread:make-thread #'thread-body) into threads
     finally
       (wake (svref *semaphores* 0))
       (wait *semaphore*)
       (dolist (i threads) (kill i))))


(start 50000000)
