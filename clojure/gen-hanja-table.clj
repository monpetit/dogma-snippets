;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-

(use '[clojure.contrib.duck-streams])

(def *txt-file* "c:/work/clojure/hanja-table.tbl")
(def *map-file* "c:/work/clojure/hanja-table.map")

(defn read-from-row-data []
  (with-in-reader *txt-file*
    (loop [lst (read *in* false 'eof)
	   hanja-table {}]
      (if (= lst 'eof) hanja-table
	  (recur (read *in* false 'eof)
		 (assoc hanja-table (keyword (str (first lst))) {:음 (second lst) :뜻 (last lst)}))))))

(def *hanja-table* (read-from-row-data))

(with-out-writer *map-file*
  (prn *hanja-table*))

;; (prn (count *hanja-table*))


;; vim: set ft=clojure
