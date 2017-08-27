
(define prc
  (case-lambda
    (() (newline))
    ((o) (begin (display o) (newline)))
    ((o . rest) (begin (display o) (display #\space) (apply prt rest)))))


(define prt
  (case-lambda
    (() (newline))
    ((o) (begin (write o) (newline)))
    ((o . rest) (begin (write o) (display #\space) (apply prt rest)))))


(define (eval-string str)
  (with-input-from-string str
    (lambda ()
      (eval (read)))))


(define-syntax define-const
  (syntax-rules ()
    ((_ name n)
     (define-syntax name (identifier-syntax n)))))

(define-syntax while
  (syntax-rules ()
    ((_ cond body ...)
     (let loop ()
       (when cond
         (begin body ...
                (loop)))))))

(define-syntax dotimes
  (syntax-rules ()
    ((_ (var n res) . body)
     (do ((limit n)
          (var 0 (+ var 1)))
         ((>= var limit) res)
       . body))
    ((_ (var n) . body)
     (do ((limit n)
          (var 0 (+ var 1)))
         ((>= var limit))
       . body))
    ((_ . other)
     (syntax-error "malformed dotimes" (dotimes . other)))))

(define indent-margin 2)

(define (print-list ls depth)
  ;; (printf (make-string (* depth indent-margin) #\space))
  (printf "(~%")
  (let ((len (length ls)))
    (let loop ((n 0))
      (when (< n len)
        (printf (make-string (* (+ depth 1) indent-margin) #\space))
        (let ((value (list-ref ls n)))
          (cond
            ((hash-table? value) (print-hash-table value (+ depth 1)))
            ((list? value) (print-list value (+ depth 1)))
            (else (printf "~s~%" value))))
        (loop (+ n 1)))))
  (printf (make-string (* depth indent-margin) #\space))
  (printf ")~%"))
  

(define (print-hash-table ht depth)
  ;; (printf (make-string (* depth indent-margin) #\space))
  (printf "{~%")
  (hash-table-for-each ht
    (lambda (key value)
      (printf (make-string (* (+ depth 1) indent-margin) #\space))
      (printf "~s : " key)
      (cond
        ((hash-table? value) (print-hash-table value (+ depth 1)))
        ((list? value) (print-list value (+ depth 1)))
        (else (printf "~s~%" value)))))
  (printf (make-string (* depth indent-margin) #\space))
  (printf "}~%"))

