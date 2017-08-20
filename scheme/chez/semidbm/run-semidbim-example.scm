
(define (prt . args)
  (for-each (lambda (x)
              (display x)
	      (display #\space))
	    args)
  (newline))


;; ---------------------------------------------------------------------------
;;   RUN
;; ---------------------------------------------------------------------------

(import (py-util))
(import (semidbm))

(py-init)
(py-sdbm-init)

(define *db* (py-sdbm-open "도그마" "c"))
(prt *db*)
(prt 'record 'length '= (py-sdbm-count *db*))
(prt (py-sdbm-keys *db*))
(prt (py-sdbm-values *db*))
(py-sdbm-store! *db* "회사명" "(주)시네마이스터")
(prt 'get 'result: (py-sdbm-get *db* "hello"))
(prt 'get 'result: (py-sdbm-get *db* "이름"))
(prt 'get 'result: (py-sdbm-get *db* "회사명"))
(prt 'record 'length '= (py-sdbm-count *db*))
(prt 'get 'result: (py-sdbm-get *db* "회사"))

(let ((count (py-sdbm-count *db*))
      (keys (py-sdbm-iterkeys *db*)))
  (let loop ((n count))
    (if (zero? n) (void)
        (let* ((key (py-sdbm-nextkey keys))
	       (value (py-sdbm-get *db* key)))
          (prt 'next-pair: key value)
	  (loop (- n 1))))))

(prt '***PAIRS***)
(prt (py-sdbm-pairs *db*))

(py-sdbm-store! *db* "노래" "하늘이 푸릅니다. 창문을 열면 온 방에 하나 가득 가슴에 가득...")
(py-sdbm-store! *db* "주제글" "
[파이썬 3.0 이후 버전의 keys 함수, 어떻게 달라졌나?]
파이썬 2.7 버전까지는 a.keys() 호출 시 리턴값으로 dict_keys가 아닌 리스트를 리턴한다. 
리스트를 리턴하기 위해서는 메모리의 낭비가 발생하는데 파이썬 3.0 이후 버전에서는 이러한 메모리 낭비를 줄이기 위해 dict_keys라는 객체를 리턴해 준다. 
다음에 소개할 dict_values, dict_items 역시 파이썬 3.0 이후 버전에서 추가된 것들이다. 
만약 3.0 이후 버전에서 리턴값으로 리스트가 필요한 경우에는 \"list(a.keys())\"를 사용하면 된다. 
dict_keys, dict_values, dict_items 등은 리스트로 변환하지 않더라도 기본적인 반복성(iterate) 구문(예: for문)들을 실행할 수 있다.
")
(prt (py-sdbm-pairs *db*))

(py-sdbm-sync! *db*)
(py-sdbm-compact! *db*)



(let ((keys (py-sdbm-iterkeys *db*)))
  (call/cc
    (lambda (break)
      (let loop ((pair (py-sdbm-nextpair *db* keys)))
        (if (not pair) (break)
  	    (prt "*****" pair))
	(loop (py-sdbm-nextpair *db* keys))))))

(if (not (zero? (py-sdbm-close! *db*)))
    (prt "error! dbm cannot closed."))

(py-run-string 	"
import re
print(dir(re))

import sys
sys.stdout.buffer.write('안녕 도그마틱 월드...\\n'.encode('utf-8'))
sys.stdout.buffer.write('어두운 미로 속을 헤매던 과거에는\\n'.encode('utf-8'))
sys.stdout.buffer.write('내가 살아가는 그 이유 몰랐지만...\\n'.encode('utf-8'))")

(py-exit)
