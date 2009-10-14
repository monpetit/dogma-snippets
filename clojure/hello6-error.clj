
(defn h-line []
  (prt '-----------------------------))

(doseq [p (System/getProperties)]
  (prt p))

(h-line)

;;(def george (create-struct :apple :banana :orange))
(defstruct george :apple :banana :orange)

(def *filepath* "c:/work/clojure/my.log")

(use '[clojure.contrib.duck-streams])



(with-out-writer *filepath*
  (prn "This goes to the file my.log.")
  (prn '(이런 것도 잘 되나요? "아마 될 걸요"))
  (prn (range 10))
  (prn "하늘이 푸릅니다...")
  (dorun
   (map prn
	(list (struct-map george :apple 3 :banana 9 :orange 12)
	      (struct-map george :apple '사과 :banana "바나나" :orange '(오렌지))
					; create a structmap with the key-val pairs :apple => 3, :banana => 9, and :orange => 12
	      (struct-map george :banana 9 :apple 3 :orange 12)
					; notice the key order need not be that used in create-struct
	      (struct-map george :apple 3 :orange 12))))
					; the key :banana is not specified, so its value defaults to nil
  (flush))


(let [infile (reader *filepath*)
      lines (line-seq infile)]
  (dorun
   (map (fn [x] (prt (type x) x)) lines)))

(h-line)

(doseq [line (read-lines *filepath*)]
  (prt (type line) line))


(h-line)

(with-in-reader *filepath*
  (loop [obj (read *in* false 'eof)]
    (if (= obj 'eof) obj
	(do
	  (prn (type obj) obj)
	  (recur (read *in* false 'eof))))))
