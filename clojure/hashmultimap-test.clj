;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-

(import 'com.google.common.collect.HashMultimap)
(use 'clojure.contrib.seq-utils)

(def table (HashMultimap/create))

(dotimes [i 1000]
  (.put table (rand-int 30) (range (rand-int 30))))

(prt "size of table =" (.size table))
(prt "count of keys =" (count (.keys table)))
(prt "count of key set =" (count (.keySet table)))

(let [firstkey (first (shuffle (.keySet table)))
      aval (.get table firstkey)]
  (doseq [v aval]
    (prt firstkey '--> v)))

(.putAll table 'hello (range 100))
(prt (.get table 'hello))

(.removeAll table 'hello )
(prt (.get table 'hello))


(let [entries (.entries table)]
  (doseq [ent entries]
    (prt (.getKey ent) '--> (.getValue ent))))



;; vim: set ft=clojure

