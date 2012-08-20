
(define-module (dogma-ffi)
  :use-module (system foreign)
  :use-module (rnrs bytevectors)
  :export (int->ptr
           ptr->int 
           c-func))

;; 유틸리티 함수
(define (int->ptr n)
  (let ((bv (make-bytevector (sizeof int))))
    (bytevector-s32-set! bv 0 n (native-endianness))
    (bytevector->pointer bv)))


(define (ptr->int p)
  (bytevector-s32-ref (pointer->bytevector p (sizeof int)) 0 (native-endianness)))


(define (c-func lib ret-type fun-name . args)
  (pointer->procedure 
    ret-type
    (dynamic-func (symbol->string fun-name) lib)
    args))


