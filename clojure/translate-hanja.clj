;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-

(use '[clojure.contrib.duck-streams])

(def *map-file* "c:/work/clojure/hanja-table.map")
(def *in-file*  "c:/work/lisp/dbtest/in.txt")
(def *out-file* "c:/work/clojure/out.txt")

(defn read-from-map-file []
  (with-in-reader *map-file*
    (read)))

;; (let [*hanja-table* (read-from-map-file)]
;;   (doseq [line (read-lines *in-file*)]
;;     (println
;;      (apply str
;; 	    (map (fn [ch]
;; 		   (let [key (symbol (str ch))]
;; 		     (or (get-in *hanja-table* [key :음])
;; 			key)))
;; 		 line))))
;;   (flush))


(defn write-to-out-file []
  (with-out-writer *out-file*
    (let [*hanja-table* (read-from-map-file)]
      (dorun
       (map (fn [line]
	      (println
	       (apply str
		      (map (fn [ch]
			     (let [key (keyword (str ch))]
			       (or (get-in *hanja-table* [key :음])
				   ch)))
			   line))))
	    (read-lines *in-file*)))
      (flush))))

(time
(write-to-out-file)
)

;; vim: set ft=clojure
