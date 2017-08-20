
(define py-sdbm-init (foreign-procedure "PyInit_python_semidbm" () void*))

(define py-sdbm-open 
  (let ((py-sdbm-open% (foreign-procedure "semidbm_open" (string string int int) void*)))
    (case-lambda
      ((filename) (py-sdbm-open% filename "r" #o666 0))
      ((filename flag) (py-sdbm-open% filename flag #o666 0))
      ((filename flag mode) (py-sdbm-open% filename flag mode 0))
      ((filename flag mode verify_checksums) (py-sdbm-open% filename flag mode verify_checksums)))))

(define py-sdbm-close! (foreign-procedure "semidbm_close" (void*) int))
(define py-sdbm-count (foreign-procedure "semidbm_count" (void*) int))
(define py-sdbm-keys% (foreign-procedure "semidbm_keys" (void*) string))			;; for debug (python output!)
(define py-sdbm-values% (foreign-procedure "semidbm_values" (void*) string))			;; for debug (python output!)
(define py-sdbm-sync! (foreign-procedure "semidbm_sync" (void*) int))
(define py-sdbm-compact! (foreign-procedure "semidbm_compact" (void*) int))
(define py-sdbm-get (foreign-procedure "semidbm_get" (void* string) string))
(define py-sdbm-store! (foreign-procedure "semidbm_store" (void* string string) int))
(define py-sdbm-iterkeys (foreign-procedure "semidbm_iterkeys" (void*) void*))
(define py-sdbm-nextkey  (foreign-procedure "semidbm_next_key" (void*) string))			;; void* ---> iterkeys (not dbm)

(define (py-sdbm-keys dbm)
  (let ((keys (py-sdbm-iterkeys dbm)))
    (let loop ((result '()) 
               (key (py-sdbm-nextkey keys)))
      (if (not key)
          (reverse result)
	  (loop (cons key result) (py-sdbm-nextkey keys))))))

(define (py-sdbm-values dbm)
  (let ((keys (py-sdbm-iterkeys dbm)))
    (let loop ((result '()) 
               (key (py-sdbm-nextkey keys)))
      (if (not key)
          (reverse result)
	  (loop (cons (py-sdbm-get dbm key) result) (py-sdbm-nextkey keys))))))

(define (py-sdbm-pairs dbm)
  (let ((keys (py-sdbm-iterkeys dbm)))
    (let loop ((result '()) 
               (key (py-sdbm-nextkey keys)))
      (if (not key)
          (reverse result)
	  (loop (cons (cons key (py-sdbm-get dbm key)) result) (py-sdbm-nextkey keys))))))

(define (py-sdbm-nextpair dbm itkeys)
  (let ((key (py-sdbm-nextkey itkeys)))
    (if (not key)
        key
	(cons key (py-sdbm-get dbm key)))))

#|

;; ---------------------------------------------------------------------------
;;   RUN EXAMPLE
;; ---------------------------------------------------------------------------

(py-init)
(py-sdbm-init)

(define smdb (py-sdbm-open "도그마" "c"))
(prt smdb)
(prt 'record 'length '= (py-sdbm-count smdb))
(prt (py-sdbm-keys smdb))
(prt (py-sdbm-values smdb))
(py-sdbm-store! smdb "회사명" "(주)시네마이스터")
(prt 'get 'result: (py-sdbm-get smdb "hello"))
(prt 'get 'result: (py-sdbm-get smdb "이름"))
(prt 'get 'result: (py-sdbm-get smdb "회사명"))
(prt 'record 'length '= (py-sdbm-count smdb))
(prt 'get 'result: (py-sdbm-get smdb "회사"))

(let ((count (py-sdbm-count smdb))
      (keys (py-sdbm-iterkeys smdb)))
  (let loop ((n count))
    (if (zero? n) (void)
        (let* ((key (py-sdbm-nextkey keys))
	       (value (py-sdbm-get smdb key)))
          (prt 'next-pair: key value)
	  (loop (- n 1))))))

(prt '***PAIRS***)
(prt (py-sdbm-pairs smdb))

(py-sdbm-store! smdb "노래" "하늘이 푸릅니다. 창문을 열면 온 방에 하나 가득 가슴에 가득...")
(py-sdbm-store! smdb "주제글" "
[파이썬 3.0 이후 버전의 keys 함수, 어떻게 달라졌나?]
파이썬 2.7 버전까지는 a.keys() 호출 시 리턴값으로 dict_keys가 아닌 리스트를 리턴한다. 
리스트를 리턴하기 위해서는 메모리의 낭비가 발생하는데 파이썬 3.0 이후 버전에서는 이러한 메모리 낭비를 줄이기 위해 dict_keys라는 객체를 리턴해 준다. 
다음에 소개할 dict_values, dict_items 역시 파이썬 3.0 이후 버전에서 추가된 것들이다. 
만약 3.0 이후 버전에서 리턴값으로 리스트가 필요한 경우에는 \"list(a.keys())\"를 사용하면 된다. 
dict_keys, dict_values, dict_items 등은 리스트로 변환하지 않더라도 기본적인 반복성(iterate) 구문(예: for문)들을 실행할 수 있다.
")
(prt (py-sdbm-pairs smdb))

(py-sdbm-sync! smdb)
(py-sdbm-compact! smdb)



(let ((keys (py-sdbm-iterkeys smdb)))
  (call/cc
    (lambda (break)
      (let loop ((pair (py-sdbm-nextpair smdb keys)))
        (if (not pair) (break)
  	    (prt "*****" pair))
	(loop (py-sdbm-nextpair smdb keys))))))

(if (not (zero? (py-sdbm-close! smdb)))
    (prt "error! dbm cannot closed."))

(py-run-string 	"
import re
import sys

def writeln(*args):
    for i in args: 
        sys.stdout.buffer.write(i)
        sys.stdout.buffer.write(b' ')
    sys.stdout.buffer.write(b'\\n')

writeln(str(dir(re)).encode('utf-8'))
writeln('안녕 도그마틱 월드...'.encode('utf-8'))
writeln('어두운 미로 속을 헤매던 과거에는'.encode('utf-8'))
writeln('내가 살아가는 그 이유 몰랐지만...'.encode('utf-8'))")


(py-exit)

|#
