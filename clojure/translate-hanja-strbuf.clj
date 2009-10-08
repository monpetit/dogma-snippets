;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-

(use '[clojure.contrib.duck-streams])
(use '[monpetit.strbuf])

(def *map-file* "c:/work/clojure/hanja-table.map")
(def *in-file*  "c:/work/lisp/dbtest/in.txt")
;;(def *in-file*  "c:/work/python/hakju.txt")
(def *out-file* "c:/work/clojure/out.txt")
(def *out-buffer* (sb-make))

(defn read-from-map-file []
  (with-in-reader *map-file*
    (read)))

(defn println-buffer [buffer strn]
  (sb-append! buffer (println-str strn)))


(defn write-to-out-buffer [buffer]
  (let [*hanja-table* (read-from-map-file)]
    (dorun
     (map (fn [line]
	    (println-buffer buffer
			    (apply str
				   (map (fn [ch]
					  (let [key (keyword (str ch))]
					    (or (get-in *hanja-table* [key :음])
						ch)))
					line))))
	  (read-lines *in-file*)))))


(defn write-to-out-file [file buffer]
  (with-out-writer file
    (print (str buffer))
    (flush)))


(time (do
(write-to-out-buffer *out-buffer*)

(write-to-out-file *out-file* *out-buffer*)
;;(print (str *out-buffer*))
))

;; vim: set ft=clojure
