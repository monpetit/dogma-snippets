;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(define x (ustr "hello"))
(define y (ustr "hello"))
(define z (ustr "가나다"))

(prtln x y z)

(prt (equal? x z))
(prt (equal? z x))
(prt (equal? x y))


(define text (ustr "가나다 원영식 블라디미르 가나다"))
(prt (ustr-find text "나다"))
(prt (ustr-find text "나다" 3))
(prt (ustr-find text "나다" 4))
(prt (ustr-find text "나다" 15))
(prt (ustr-find text (ustr-substr text 1 2) 3))
(set! text (ustr-cdr text))
(prt (ustr-find text "나다"))
(prt (ustr-find text "나다" 3))
(prt (ustr-find text "나다" 4))
(prt (ustr-find text "나다" 15))


(set! text (ustr "하늘이 푸릅니다. 창문을 열면 온방에 하나 가득 가슴에 가득... 잔잔한 호수 같은 먼 하늘에 푸름드리 드리운 아침입니다. 아가는 잠자고 예쁜 아가는 잠자고..."))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (reverse (ustr->list text)))
(prt (ustr->list text))

(set! text (ustr "하늘이 푸릅니다. 창문을 열면 온방에 하나 가득 가슴에 가득... 잔잔한 호수 같은 먼 하늘에 푸름드리 드리운 아침입니다. 아가는 잠자고 예쁜 아가는 잠자고..."))

(set! text (ustr->list text))
(map prt text)
(map prt (reverse text))

(set! text (ustr "하늘이 푸릅니다. 창문을 열면 온방에 하나 가득 가슴에 가득... 잔잔한 호수 같은 먼 하늘에 푸름드리 드리운 아침입니다. 아가는 잠자고 예쁜 아가는 잠자고..."))

(prt (ustr-substr text 5 30))
(prt (ustr-substr text 1 10))
(prt (ustr-substr text 5 30))
(prt (ustr-substr text 3 50))
(prt (ustr-substr text 0 30))

(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))
(prt (ustr->list text))

(set! text (ustr->list text))
(for-each prt text)
(for-each prt (reverse text))


(define msg (ustr "vladimir Monpetit 하마스키"))
(prtln msg
       (ustr-upper msg)
       (ustr-lower (ustr-upper msg)))
