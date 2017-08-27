
(define (prt* . args)
  (for-each (lambda (x) (printf "~s " x)) args)
  (newline))

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

(define-syntax json-define
  (syntax-rules ()
    ((_ name n)
     (define-syntax name (identifier-syntax n)))))

;; ------------------------------------------------------------------------
;; CONSTANTS
;; ------------------------------------------------------------------------
(json-define JSON:OBJECT        0)
(json-define JSON:ARRAY         1)
(json-define JSON:STRING        2)
(json-define JSON:INTEGER       3)
(json-define JSON:REAL          4)
(json-define JSON:TRUE          5)
(json-define JSON:FALSE         6)
(json-define JSON:NULL          7)

(json-define JSON:MAXREFCOUNT   #xffffffffffffffff)

(json-define JSON:ERROR_TEXT_LENGTH    160)
(json-define JSON:ERROR_SOURCE_LENGTH   80)

(json-define JSON:REJECT_DUPLICATES  #x1)
(json-define JSON:DISABLE_EOF_CHECK  #x2)
(json-define JSON:DECODE_ANY         #x4)
(json-define JSON:DECODE_INT_AS_REAL #x8)
(json-define JSON:ALLOW_NUL          #x10)

(json-define JSON:MAX_INDENT         #x1F)
(define (JSON:INDENT n) (bitwise-and n JSON:MAX_INDENT))
(json-define JSON:COMPACT            #x20)
(json-define JSON:ENSURE_ASCII       #x40)
(json-define JSON:SORT_KEYS          #x80)
(json-define JSON:PRESERVE_ORDER     #x100)
(json-define JSON:ENCODE_ANY         #x200)
(json-define JSON:ESCAPE_SLASH       #x400)
(define (JSON:REAL_PRECISION n) (bitwise-arithmetic-shift-left (bitwise-and n #x1f) 11))
(json-define JSON:EMBED              #x10000)


;; 구조체 정의

(define-ftype json_type int)
(define-ftype json_int_t long-long)

(define-ftype json_t
  (struct
    (type json_type)
    (refcount size_t)))

(define-ftype json_error_t
  (struct
    (line int)
    (column int)
    (position int)
    (source (array 80 char))
    (text (array 160 char))))

(define-syntax fptr-free
  (syntax-rules ()
    ((_ ptr)
     (begin
       (foreign-free (ftype-pointer-address js)) ;; 구조체 변수 제거
       (set! js (void))))))


(define NULL (make-ftype-pointer char 0))
;; (define (foreign-null-pointer type) (make-ftype-pointer type #x00000000))

(define-syntax json-prop-get
  (syntax-rules ()
    ((_ (field) ptr) (ftype-ref json_t (field) ptr))))

(define-syntax json-prop-set!
  (syntax-rules ()
    ((_ (field) ptr value) (ftype-set! json_t (field) ptr value))))

(define (js<t> ptr)
  (json-prop-get (type) ptr))

(define (js<r> ptr)
  (json-prop-get (refcount) ptr))

(define (js<t>! ptr value)
  (json-prop-set! (type) ptr value))

(define (js<r>! ptr value)
  (json-prop-set! (refcount) ptr value))

(define (not-nullptr? ptr)
  (not (ftype-pointer-null? ptr)))

(define-ftype bvcopy_t (function (u8* void* size_t) void))
(define bvcopy-fptr (make-ftype-pointer bvcopy_t "memcpy"))
(define bvcopy (ftype-ref bvcopy_t () bvcopy-fptr))

(define-ftype bv_strcopy_t (function (u8* void*) void))
(define bv_strcopy-fptr (make-ftype-pointer bv_strcopy_t "strcpy"))
(define bv_strcopy (ftype-ref bv_strcopy_t () bv_strcopy-fptr))


(define (json-typeof js)
  (if (ftype-pointer-null? js)
      #f
      (js<t> js)))

(define (json-object? js) (= (json-typeof js) JSON:OBJECT))
(define (json-array? js) (= (json-typeof js) JSON:ARRAY))
(define (json-string? js) (= (json-typeof js) JSON:STRING))
(define (json-integer? js) (= (json-typeof js) JSON:INTEGER))
(define (json-real? js) (= (json-typeof js) JSON:REAL))
(define (json-true? js) (= (json-typeof js) JSON:TRUE))
(define (json-false? js) (= (json-typeof js) JSON:FALSE))
(define (json-null? js) (= (json-typeof js) JSON:NULL))
(define json-boolean-value json-true?)

(define (json-incref! js)
  (if (and (not-nullptr? js)
           (not (= (js<r> js) JSON:MAXREFCOUNT)))
      (js<r>! js (+ (js<r> js) 1)))
  js)

(define json-delete%! (foreign-procedure "json_delete" ((* json_t)) void))
(define (json-decref! js)
  (when (and (not-nullptr? js)
             (not (= (js<r> js) JSON:MAXREFCOUNT)))
    (js<r>! js (- (js<r> js) 1))
    (if (zero? (js<r> js))
        (json-delete%! js))))

;; (define json-incref (foreign-procedure "json_incref" ((* json_t)) (* json_t)))
;; (define json-decref (foreign-procedure "json_decref" ((* json_t)) void))

(define json-true (foreign-procedure "json_true" () (* json_t)))
(define json-false (foreign-procedure "json_false" () (* json_t)))
(define (json-boolean val)
  (if val (json-true) (json-false)))
(define json-null (foreign-procedure "json_null" () (* json_t)))
(define json-string (foreign-procedure "json_string" (string) (* json_t)))
(define json-stringn (foreign-procedure "json_stringn" (string size_t) (* json_t)))
(define json-string-nocheck (foreign-procedure "json_string_nocheck" (string size_t) (* json_t)))
(define json-stringn-nocheck (foreign-procedure "json_stringn_nocheck" (string size_t) (* json_t)))
(define json-string-value (foreign-procedure "json_string_value" ((* json_t)) string))
(define json-string-length (foreign-procedure "json_string_length" ((* json_t)) size_t))
(define json-string-set! (foreign-procedure "json_string_set" ((* json_t) string) int))
(define json-string-setn! (foreign-procedure "json_string_setn" ((* json_t) string size_t) int))
(define json-string-set-nocheck! (foreign-procedure "json_string_set_nocheck" ((* json_t) string) int))
(define json-string-setn-nocheck! (foreign-procedure "json_string_setn_nocheck" ((* json_t) string size_t) int))
(define json-integer (foreign-procedure "json_integer" (json_int_t) (* json_t)))
(define json-integer-value (foreign-procedure "json_integer_value" ((* json_t)) json_int_t))
(define json-integer-set! (foreign-procedure "json_integer_set" ((* json_t) json_int_t) int))
(define json-real (foreign-procedure "json_real" (double) (* json_t)))
(define json-real-value (foreign-procedure "json_real_value" ((* json_t)) double))
(define json-real-set! (foreign-procedure "json_real_set" ((* json_t) double) int))
(define json-number-value (foreign-procedure "json_number_value" ((* json_t)) double))
(define json-array (foreign-procedure "json_array" () (* json_t)))
(define json-array-size (foreign-procedure "json_array_size" ((* json_t)) size_t))
(define json-array-get (foreign-procedure "json_array_get" ((* json_t) size_t) (* json_t)))
(define json-array-set-new! (foreign-procedure "json_array_set_new" ((* json_t) size_t (* json_t)) int))
(define (json-array-set! arr index js)
  (json-array-set-new! arr index (json-incref! js)))
(define json-array-append-new! (foreign-procedure "json_array_append_new" ((* json_t) (* json_t)) int))
(define (json-array-append! arr js)
  (json-array-append-new! arr (json-incref! js)))
(define json-array-insert-new! (foreign-procedure "json_array_insert_new" ((* json_t) size_t (* json_t)) int))
(define (json-array-insert! arr index js)
  (json-array-insert-new! arr index (json-incref! js)))
(define json-array-remove! (foreign-procedure "json_array_remove" ((* json_t) size_t) int))
(define json-array-clear! (foreign-procedure "json_array_clear" ((* json_t)) int))
(define json-array-extend! (foreign-procedure "json_array_extend" ((* json_t) (* json_t)) int))

;; json_array_foreach(array, index, value)

(define-syntax json-array-foreach
  (syntax-rules ()
    ((_ (array index value) body ...)     
     (let ((__array_len% (json-array-size array))
           (value #f))
       (let loop ((index 0))
         (when (< index __array_len%)
           (set! value (json-array-get array index))
           body
           ...
           (loop (+ index 1))))))
    ((_ (array value) body ...)     
     (let ((__array_len% (json-array-size array))
           (value #f))
       (let loop ((index 0))
         (when (< index __array_len%)
           (set! value (json-array-get array index))
           body
           ...
           (loop (+ index 1))))))))


(define json-object (foreign-procedure "json_object" () (* json_t)))
(define json-object-size (foreign-procedure "json_object_size" ((* json_t)) size_t))
(define json-object-get (foreign-procedure "json_object_get" ((* json_t) string) (* json_t)))
(define json-object-set-new! (foreign-procedure "json_object_set_new" ((* json_t) string (* json_t)) int))
(define (json-object-set! object key value)
  (json-object-set-new! object key (json-incref! value)))
(define json-object-set-new-nocheck! (foreign-procedure "json_object_set_new_nocheck" ((* json_t) string (* json_t)) int))
(define (json-object-set-nocheck! object key value)
  (json-object-set-new-nocheck! object key (json-incref! value)))
(define json-object-del! (foreign-procedure "json_object_del" ((* json_t) string) int))
(define json-object-clear! (foreign-procedure "json_object_clear" ((* json_t)) int))
(define json-object-update! (foreign-procedure "json_object_update" ((* json_t) (* json_t)) int))
(define json-object-update-existing! (foreign-procedure "json_object_update_existing" ((* json_t) (* json_t)) int))
(define json-object-update-missing! (foreign-procedure "json_object_update_missing" ((* json_t) (* json_t)) int))
;; json_object_foreach(object, key, value)
;; json_object_foreach_safe(object, tmp, key, value)
(define json-object-iter (foreign-procedure "json_object_iter" ((* json_t)) void*))
(define json-object-iter-at (foreign-procedure "json_object_iter_at" ((* json_t) string) void*))
(define json-object-iter-next (foreign-procedure "json_object_iter_next" ((* json_t) void*) void*))
(define json-object-iter-key (foreign-procedure "json_object_iter_key" (void*) string))
(define json-object-iter-value (foreign-procedure "json_object_iter_value" (void*) (* json_t)))
(define json-object-iter-set-new! (foreign-procedure "json_object_iter_set_new" ((* json_t) void* (* json_t)) int))
(define (json-object-iter-set! object iter value)
  (json-object-iter-set-new! object iter (json-incref! value)))
(define json-object-key-to-iter (foreign-procedure "json_object_key_to_iter" (string) void*))

(define-syntax json-object-foreach
  (syntax-rules ()
    ((_ (object key value) body ...)
     (let ((key #f)
           (value #f)
           (iter (json-object-iter object)))
       (while (not (= iter 0))
         (set! key (json-object-iter-key iter))	 
	 (set! value (json-object-iter-value iter))
	 (when (and key value)
	   body
	   ...)
	 (set! iter (json-object-iter-next object iter)))))))

(define (json-dump->utf8 js)
  (let ((json-dumpb-get-size% (foreign-procedure "json_dumpb" ((* json_t) (* char) size_t size_t) size_t))
        (json-dumpb-get-buffer% (foreign-procedure "json_dumpb" ((* json_t) u8* size_t size_t) size_t)))    
    (let* ((dp-size (json-dumpb-get-size% js NULL 0 0))
           (buffer (make-bytevector dp-size 0)))
      (if (positive? dp-size)
          (json-dumpb-get-buffer% js buffer dp-size 0))
      buffer)))

(define (json-dump->string js)
  (utf8->string (json-dump->utf8 js)))

(define (json-dump->file js path)
  (let ((json-dump-file% (foreign-procedure "json_dump_file" ((* json_t) string size_t) int)))
    (json-dump-file% js path 0)))

(define (json-error->sexpr error)
  (let ((error-source (make-bytevector JSON:ERROR_SOURCE_LENGTH 0))
        (error-text (make-bytevector JSON:ERROR_TEXT_LENGTH 0))
	(ht (make-hash-table)))
    (put-hash-table! ht 'line (ftype-ref json_error_t (line) error))
    (put-hash-table! ht 'column (ftype-ref json_error_t (column) error))
    (put-hash-table! ht 'position (ftype-ref json_error_t (position) error))
    (bv_strcopy error-source (ftype-pointer-address (ftype-&ref json_error_t (source) error)))
    (bv_strcopy error-text (ftype-pointer-address (ftype-&ref json_error_t (text) error)))
    (put-hash-table! ht 'source (utf8->string error-source))
    (put-hash-table! ht 'text (utf8->string error-text))
    ht))

;; private function
(define (json-load<-string% buffer flags)
  (let ((json-loads (foreign-procedure "json_loads" (string size_t (* json_error_t)) (* json_t)))
        (error (make-ftype-pointer json_error_t (foreign-alloc (ftype-sizeof json_error_t)))))
    (let ((js (json-loads buffer flags error))
          (result (void)))
      (if (ftype-pointer-null? js) ;; 에러 발생(NULL)?
          (let ((err (json-error->sexpr error)))
	    (hash-table-for-each err (lambda (key value) (prt* key value)))
	    (set! result (cons (void) err)))
	  (set! result (cons js (void))))
      (foreign-free (ftype-pointer-address error)) ;; 구조체 변수 제거
      result)))

;; PUBLIC FUCNTION
(define json-load<-string
  (case-lambda
    ((buffer) (json-load<-string% buffer 0))
    ((buffer flags) (json-load<-string% buffer flags))))

;; private function
(define (json-load<-file% path flags)
  (let ((json-load-file (foreign-procedure "json_load_file" (string size_t (* json_error_t)) (* json_t)))
        (error (make-ftype-pointer json_error_t (foreign-alloc (ftype-sizeof json_error_t)))))
    (let ((js (json-load-file path flags error))
          (result (void)))
      (if (ftype-pointer-null? js) ;; 에러 발생(NULL)?
          (let ((err (json-error->sexpr error)))
	    (hash-table-for-each err (lambda (key value) (prt* key value)))
	    (set! result (cons (void) err)))
	  (set! result (cons js (void))))
      (foreign-free (ftype-pointer-address error)) ;; 구조체 변수 제거
      result)))

;; PUBLIC FUCNTION
(define json-load<-file
  (case-lambda
    ((path) (json-load<-file% path 0))
    ((path flags) (json-load<-file% path flags))))

;; PUBLIC FUCNTION
(define (json->sexpr js)
  (cond
    ((json-object? js) (let ((ht (make-hash-table)))
                         (json-object-foreach (js key value)
                           (put-hash-table! ht
                                            (string->symbol key)
                                            (json->sexpr value)))
                         ht))
    ((json-array? js) (let ((array '()))
                        (json-array-foreach (js value)
                          (set! array (cons (json->sexpr value) array)))
			(reverse array)))
    ((json-string? js) (json-string-value js))
    ((json-integer? js) (json-integer-value js))
    ((json-real? js) (json-real-value js))
    ((json-true? js) (json-boolean-value js))
    ((json-false? js) (json-boolean-value js))
    ((json-null? js) '())))


(define (sexpr->json object)
  (cond
    ((hash-table? object) (let ((js (json-object)))
                            (hash-table-for-each object
                              (lambda (key value)                                                   
                                (json-object-set-new! js (if (symbol? key)
                                                             (symbol->string key)
                                                             key)
                                                      (sexpr->json value))))
                            js))
    ((list? object) (let ((js (json-array))
                          (len (length object)))
                      (let loop ((n 0))
                        (when (< n len)
                          (json-array-append-new! js (sexpr->json (list-ref object n)))
                          (loop (+ n 1))))
                      js))
    ((vector? object) (sexpr->json (vector->list object)))
    ((string? object) (json-string object))
    ((integer? object) (json-integer object))
    ((real? object) (json-real object))
    ((boolean? object) (or (and (eq? object #t) (json-true)) (json-false)))
    ((null? object) (json-null))
    ((symbol? object) (sexpr->json (symbol->string object)))
    (else (json-null))))



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

