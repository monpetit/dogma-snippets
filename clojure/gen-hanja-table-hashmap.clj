;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-

(use '[clojure.contrib.duck-streams])

(def *txt-file* "c:/work/clojure/hanja-table.tbl")
(def *map-file* "c:/work/clojure/hanja-table.map2")

(def *hanja-table* (java.util.HashMap. ))


(defn read-from-row-data []
  (with-in-reader *txt-file*
    (loop [lst (read *in* false 'eof) i 0]
      (try
       (.put *hanja-table* (first lst) (java.util.HashMap. {'음 (second lst) '뜻 (last lst)}))
       (catch Exception e
	 'who-care?))
      (if (= lst 'eof) 'done
	  (recur (read *in* false 'eof) (+ i 1))))))

(read-from-row-data)

;; (with-out-writer *map-file*
;;   (prn *hanja-table*))

(let [oos (java.io.ObjectOutputStream. (java.io.FileOutputStream. *map-file*))]
  (.writeObject oos *hanja-table*))

;; vim: set ft=clojure
