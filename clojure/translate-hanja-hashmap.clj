;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-

(use '[clojure.contrib.duck-streams])
(use '[monpetit.strbuf])

(def *map-file* "c:/work/clojure/hanja-table.map2")
(def *in-file*  "c:/work/lisp/dbtest/in.txt")
(def *out-file* "c:/work/clojure/out.txt")
(def *out-buffer* (sb-make))

(defn read-from-map-file []
  (let [ois (java.io.ObjectInputStream. (java.io.FileInputStream. *map-file*))]
    (.readObject ois)))

(defn println-buffer [buffer strn]
  (sb-append! buffer (println-str strn)))


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


(defn write-to-out-buffer [buffer]
    (let [*hanja-table* (read-from-map-file)]
      (dorun
       (map (fn [line]
	      (println-buffer buffer
	       (apply str
		      (map (fn [ch]
			     (let [key (symbol (str ch))
				   field (.get *hanja-table* key)]
			       (if field (.get field '음) key)))
			   line))))
	    (read-lines *in-file*)))
      ))

;; (defn write-to-out-file []
;;   (with-out-writer *out-file*
;;     (let [*hanja-table* (read-from-map-file)]
;;       (doseq [line (read-lines *in-file*)]
;; 	(doseq [ch line]
;; 	  (print (or (.get (.get *hanja-table* key) '음)
;; 		     key))))
;;       (flush))))


(defn write-to-out-file [file buffer]
  (with-out-writer file
    (print (str buffer))
    (flush)))


(time (do
(write-to-out-buffer *out-buffer*)
(write-to-out-file *out-file* *out-buffer*)
))

;; vim: set ft=clojure
