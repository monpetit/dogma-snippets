
(prtln
 (let [x 2]
   (+ x 8))
 (let [x 2 y 7]
   (* x y))
 (let [x 10 y (* x 2) z (* y 3)]
   (vector x y z))
 (let [color 'Red]
   (str "Color is " color)))

(prt (new java.util.Date))
(prt (. (new java.util.Date) (toString)))
(println (new StringBuffer "This is the initial value"))

(prtln
 (. (new java.util.HashMap) (containsKey "key"))
 (. Boolean (valueOf "true"))
 (. Integer MAX_VALUE)
)


(import '(java.io FileReader))

(prt (FileReader. "Monpetit.java"))

(import '(java.io File) '(java.util HashMap))



;;
(loop [i 0]
  (when (< i 5)
    (prt "i =" i)
    (recur (inc i))))

(def max-count 10000000)

(prtln
 (time (loop [i 0]
	 (when (< i max-count)
	   (recur (inc i)))))

 (time (dorun (for [i (range max-count)]
		0)))

 (time (doseq [i (range max-count)]
	 0)))


(doseq [i (range 5)]
  (prt "i =" i))

(apply prtln (map #(str "i = " %) (range 5)))


(prtln
 (type (seq [1 2 3]))
 (.getClass (seq [1 2 3])))

