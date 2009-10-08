;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f
;; then enter the text in that file's own buffer.

(defn factorial
  ([n]
     (factorial n 1))
  ([n acc]
     (if (= n 0) acc
	 (recur (dec n) (* acc n)))))


(factorial 10)

(let [lst (range 10)]
  (dorun
   (map prt lst (map factorial lst))))



;; (prt (factorial 10000))


(defn show-me-the-money [money]
  (loop [m money n 0]
    (println m n)
    (if-not (zero? m)
      (recur (- m 1) (+ n 1)))))


(show-me-the-money 5)

(prt '(안녕...))
