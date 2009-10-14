
(use '[monpetit.strbuf])

(def *out-buffer* (sb-make))

(doseq [i (range 100)]
  (sb-append! *out-buffer*
	      (println-str "i =" i)))

(dorun
 (map #(sb-append! *out-buffer* %)
      (map println-str
	   (map (fn [x y]
		  (list x y))
		(range 10)
		(range 10)))))


(print
 (str *out-buffer*))


