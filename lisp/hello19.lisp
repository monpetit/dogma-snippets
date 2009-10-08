;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defmacro for ((var start stop &optional (step 1)) &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (+ ,var ,step))
          (,gstop ,stop))
         ((> ,var ,gstop))
       ,@body)))

(for (i 10 20 2)
  (prt i))
(for (i 10 100)
  (prt i)
  (prt 'hello))


(for (i 0 3)
  (for (j 0 4)
    (prt (list i j))))


(ppmx (for (i 0 10 2)
        (prt i)))
