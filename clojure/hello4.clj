;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f
;; then enter the text in that file's own buffer.

(prt '222)
(prt (= (seq [1 2 3]) '(1 2 3)))


(let [dic {1 2 3 4 "5" '6 :7 8}]
  (prt dic)
  (prt (dic 1))
  (prt (:7 dic))
  (prt (dic :7))
  (prt (:1 dic)))

(prtln
 (keyword "test")
 (keyword "monpetit" "test")
 (keyword "dogma/test"))

(prt
 (quote (a b c 한글)))


(defn factorial [n]
  (defn fac [n acc]
    (if (zero? n)
      acc
      (recur (- n 1) (* acc n))))
  (fac n 1))


(factorial 10)

(dotimes [i 20]
  (prt i (factorial i)))


;;(comment
  (try
   (catch java.lang.Error e
       (throw (new java.lang.Error "뭔가 던졌는데 받았는지요?"))
       (prt e)
       )
   (finally
    (prt '에러가-나도-반드시-이건-출력되어야-함)))
;;)


(. String valueOf \c)


(prt (new String "가나다 블라디미르"))

(prtln
 (type (String. "몽쁘띠 하마스키"))
 (type "몽쁘띠 하마스키"))

(defn words [text] (re-seq #"[가-힣a-z]+" (.toLowerCase text)))
(def 출력 prt)
(apply 출력 (words "블라디미르 몽쁘띠 hama take down\t헐...heee"))



(defn rabbit [] 3)
(prtln
 `(moose ~(rabbit))     ; (quote (cat/moose 3))   ...assume namespace cat
 `(moose ~rabbit))


(def zebra [1 2 3])
(prtln
 `(moose ~zebra)        ; (quote (cat/moose [1 2 3]))
 `(moose ~@zebra))      ; (quote (cat/moose 1 2 3))

(prt
 `(x1 x2 x3 ... xn))


(def pointless (fn [x] x))
(prt
 (pointless 4)
 (pointless (+ 3 5)))

(defmacro ptls [x] x)
(prt
 (ptls 4)
 (ptls (+ 3 5)))


(def random (new java.util.Random))
(. random nextInt)

(dotimes [i 100]
  (prt (. random nextInt)))

(defn collect-rand [n]
  (loop [cnt n result '[]]
    (if (zero? cnt)
      result
      (recur (dec cnt) (conj result (. random nextInt))))))

(collect-rand 10)
(apply prtln
       (collect-rand 10))


;;
;;
(def person (create-struct :name
			   :age
			   :height))
(def p (struct person '송쌤 65 155))

(type (struct-map person))

(prt p)
