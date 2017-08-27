#!chezscheme

(library (jansson)
  (export
    JSON:OBJECT
    JSON:ARRAY
    JSON:STRING
    JSON:INTEGER
    JSON:REAL
    JSON:TRUE
    JSON:FALSE
    JSON:NULL

    JSON:REJECT_DUPLICATES 
    JSON:DISABLE_EOF_CHECK
    JSON:DECODE_ANY
    JSON:DECODE_INT_AS_REAL
    JSON:ALLOW_NUL

    JSON:MAX_INDENT
    JSON:INDENT
    JSON:COMPACT
    JSON:ENSURE_ASCII
    JSON:SORT_KEYS
    JSON:PRESERVE_ORDER
    JSON:ENCODE_ANY
    JSON:ESCAPE_SLASH
    JSON:REAL_PRECISION
    JSON:EMBED

    not-nullptr?

    json-typeof
    json-object?
    json-array?
    json-string?
    json-integer?
    json-real?
    json-true?
    json-false?
    json-null?
    json-boolean-value
    json-incref!
    json-decref!
    json-true
    json-false
    json-boolean
    json-null
    json-string
    json-stringn
    json-string-nocheck
    json-stringn-nocheck
    json-string-value
    json-string-length
    json-string-set!
    json-string-setn!
    json-string-set-nocheck!
    json-string-setn-nocheck!
    json-integer
    json-integer-value
    json-integer-set!
    json-real
    json-real-value
    json-real-set!
    json-number-value
    json-array
    json-array-size
    json-array-get
    json-array-set-new!
    json-array-set!
    json-array-append-new!
    json-array-append!
    json-array-insert-new!
    json-array-insert!
    json-array-remove!
    json-array-clear!
    json-array-extend!
    json-array-foreach

    json-object
    json-object-size
    json-object-get
    json-object-set-new!
    json-object-set!
    json-object-set-new-nocheck!
    json-object-set-nocheck!
    json-object-del!
    json-object-clear!
    json-object-update!
    json-object-update-existing!
    json-object-update-missing!
    json-object-iter
    json-object-iter-at
    json-object-iter-next
    json-object-iter-key
    json-object-iter-value
    json-object-iter-set-new!
    json-object-iter-set!
    json-object-key-to-iter
    json-object-foreach

    json-dump->utf8                     ;; json 오브젝트를 scheme bytevector로...
    json-dump->string                   ;; json 오브젝트를 scheme string으로...
    json-dump->file                     ;; json 오브젝트를 파일로 저장
    json-load<-string                   ;; scheme string을 json 오브젝트로...
    json-load<-file                     ;; 파일을 읽어 json 오브젝트로...
    json->sexpr                         ;; json 오브젝트를 scheme 오브젝트로...
    sexpr->json                         ;; scheme 오브젝트를 json 오브젝트로...

    json-error->sexpr                   ;; json 에러를 scheme 오브젝트로...

    print-list
    print-hash-table)
  (import (chezscheme))

  (define no-op1 (load-shared-object "libjansson-4.dll"))
  (define no-op2 (load-shared-object "msvcrt.dll"))

  (include "json.scm"))


