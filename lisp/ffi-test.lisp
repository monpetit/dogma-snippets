;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(sb-alien:load-shared-object "test.dll")
(sb-alien:define-alien-routine "test_fun" int
  (i int))

(loop for x from 0 to 1000
     do (prt (test-fun x)))

(dolist (x (range 100))
  (prt x '---> (test-fun x)))