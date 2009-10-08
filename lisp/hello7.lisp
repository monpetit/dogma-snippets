;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(labels
    ((len (lst)
       (if (null lst)
           0
           (1+ (len (cdr lst))))))
  (prt
    (len '(한국 근 현대사 교과서))))

(defun nonsense (k x z)
  (foo z x)                     ;First call to foo
  (let ((j (foo k x))           ;Second call to foo
        (x (* k k)))
    (declare (inline foo) (special x z))
    (foo x j z)))               ;Third call to foo


(defun strangep (x)
  (declare (author "Vladimir Monpetit"))
  (member x '(strange weird odd peculiar)))

(strangep 'weird)
