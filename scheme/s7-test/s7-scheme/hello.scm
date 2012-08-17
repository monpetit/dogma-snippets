
(define x 10)
(define y '가나다)
(define z "블라디미르")

(define (prt . args) (for-each (lambda (x) (display x) (newline)) args))

(prt x)
(prt y)
(prt z)


;; hash-table functions
(define (hash-table-keys h) (map car h))
(define (hash-table-values h) (map cdr h))
