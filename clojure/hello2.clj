;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f
;; then enter the text in that file's own buffer.

;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f
;; then enter the text in that file's own buffer.

(def 변수 '(세상엔 내가 너무도 많아 당신의 쉴 곳 없네))
(println 변수)

(defn mapprt [seq]
  (doseq [x seq]
    (println x)))

(mapprt 변수)


(def x 1000)
(println x)

(println '("가나다" "도그마" "하늘"))
(println '하늘)
(println '가을)

(def xxx '(하늘 다람쥐 가을 높이 올라라))
(println xxx)


(doseq [x '(하늘 다람쥐 가을 높이 올라라)]
  (println x))


(def dic {:a 1 :b 2 :c 3})
(doseq [k (keys dic)]
  (println k (k dic)))


(def fx (fn [x] (+ x 100)))
(fx 1000)
(let [a (map fx (range 10))]
  (println a))

(defn prtln [& more]
  (doseq [x more]
    (println x)))

(prtln 30 'a 303 "가나다")


(defn prt [& more]
  (println
   (apply str
	  (map (fn [x] (str x " "))
	       more))))

(apply prt (range 10))
(apply prtln (range 10))
(apply prtln '(하늘이 푸릅니다 창문을 열면 온 방에 하나 가득 가슴에 가득...))
(apply prt '(하늘이 푸릅니다 창문을 열면 온 방에 하나 가득 가슴에 가득...))

(prt 30)
