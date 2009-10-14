
(defun n!-loop (n)
  (loop with result = 1
        for i from 1 to n
        do (setf result (* result i))
        finally (return result)))

(defun n!-tail (n)
  (labels ((n! (i result)
             (if (> i n)
                 result
                 (n! (1+ i) (* i result)))))
    (n! 1 1)))

;; (compile 'n!-loop)
;; (compile 'n!-tail)

(time (progn (n!-loop 100000) nil))
;;Evaluation took:
;;  15.989 seconds of real time
;;  14.596912 seconds of user run time
;;  0.63204 seconds of system run time
;;  [Run times include 1.26 seconds GC run time.]
;;  0 calls to %EVAL
;;  0 page faults and
;;  9,029,652,712 bytes consed.

(time (progn (n!-tail 100000) nil))
;;Evaluation took:
;;  16.115 seconds of real time
;;  14.684918 seconds of user run time
;;  0.592037 seconds of system run time
;;  [Run times include 1.344 seconds GC run time.]
;;  0 calls to %EVAL
;;  0 page faults and
;;  9,029,668,056 bytes consed.
