
(println
  (member 'b '(a b c))
  (member '(b) '((a) (b) (c)))
  (member '(b) '((a) (b) (c)) :test #'equal)
  (member 'a '((1 2) (a b) (x y)) :test #'equal)
  (member 'a '((1 2) (a b) (x y)) :key #'car)
  (member-if #'oddp (range 5))
  )


(labels ((our-member-if (fn lst)
           (and (consp lst)
                (if (funcall fn (car lst))
                    lst
                    (our-member-if fn (cdr lst))))))
  (our-member-if #'oddp (range 5)))


(defun sprintf (&rest args)
  (apply #'format (cons nil args)))


(let ((lst '(a b c)))
  (princln
    (adjoin 'b lst)
    (adjoin 'z lst)
    (sprintf "합집합: ~a" (union lst '(c b s)))                  ;; 합집합
    (sprintf "교집합: ~a" (intersection lst '(b b c)))           ;; 교집합
    (sprintf "차집합: ~a" (set-difference '(a b c d e) '(b e)))  ;; 차집합
    ))


(let ((lst '(a b c d e f g)))
  (princln
    (sprintf "리스트: ~s" lst)
    (sprintf "길이: ~s" (length lst))
    (sprintf "subseq 1 2: ~s" (subseq lst 1 2))
    (sprintf "subseq 1: ~s" (subseq lst 1))
    (sprintf "reverse: ~s" (reverse lst))
    ))

(flet ((mirror? (seq)
         (let ((len (length seq)))
           (and (evenp len)
                (let ((mid (/ len 2)))
                  (equal (subseq seq 0 mid)
                         (reverse (subseq seq mid))))))))
  (mapcar #'(lambda (s)
              (prc (sprintf "mirror? ~s: ~s" s (mirror? s))))
          '((a b b a)
            (a b b c)
            (a b a)
            (0 1 2 2 1 0)
            (a b x b a)
            (a a)
            (a)
            ())))


(let* ((a '(0 2 1 3 8 -4))
       (b (copy-list a)))
  (prt a b)
  (prt a (sort a #'>))
  (prt b (stable-sort b #'>))
  (prt a b))



(let ((a '(0 2 -7 3 8 -5)))
  (let ((b a))
    (prt 1 a b)
    (setf b (prt (stable-sort b #'<)))
    (prt 2 a b))
  (prt 3 a))


(mapcar #'(lambda (exp)
            (prc exp (eval exp)))
        '((every #'oddp '(1 3 5))
          (some #'evenp '(1 2 3 4))
          (every #'> '(1 3 5) '(0 2 4))
          (some #'> '(0 1 2) '(3 4 5))))


(let ((stack '(b)))
  (println
    stack
    (push 'a stack)
    (push 1 stack)
    (push 'hello stack)
    (push "안녕" stack)
    (pop stack)
    (pop stack)
    (pop stack)
    (pop stack)
    stack))


(flet ((our-reverse (lst)
         (let ((result nil))
           (dolist (item lst)
             (push item result))
           result)))
  (let ((one '(17분 칼라 완성 모닝 스튜디오)))
    (println
      one
      (our-reverse one))))

(let ((lst '(a b c)))
  (println
    lst
    (pushnew 'x lst)
    (pushnew 'c lst)))


(let ((trans '((+ . add)
               (- . subtract))))
  (println
    (assoc '+ trans)
    (assoc '* trans)
    (assoc '- trans)))


(labels ((our-assoc (key lst)
           (and (consp lst)
                (let ((pair (car lst)))
                  (if (eql key (car pair))
                      pair
                      (our-assoc key (cdr lst)))))))
  (let ((trans '((+ . add)
                 (- . subtract))))
    (println
      (our-assoc '+ trans)
      (our-assoc '* trans)
      (our-assoc '- trans))))
