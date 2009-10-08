;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(require :metabang-bind)
(import 'metabang-bind:bind)

(bind ((a 2)
       (b 1))
  (dm:prt a b))


(bind ((a 2)
       b c d e f)
  (dm:prt a b c d e f))

(bind ((a 2)
       (b (+ a 5))
       (c (+ a b)))
  (dm:prt a b c))

(bind (((a b) '(3 4)))
  (dm:prt a b))

(bind (((:values a b) (values 3 4))
       ((c d) '(-2 -5)))
  (dm:prt (list a b c d)))
