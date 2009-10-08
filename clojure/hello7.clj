;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f
;; then enter the text in that file's own buffer.

(use '[clojure.contrib.repl-utils])
(require 'clojure.contrib.mmap)

(def msg (clojure.contrib.mmap/slurp "c:/work/clojure/hello5-fact.clj"))

(println msg)

(def msg2 (slurp "c:/work/clojure/hello5-fact.clj"))


(defn read-file [f]
  (let [data (clojure.contrib.mmap/slurp f)]
    (clojure.contrib.str-utils/re-gsub #"\r" "" (.toString data))))



(try
 (throw(Exception."뭔가 이상해서 메시지를 던졌습니다요."))
 (catch Exception e
   (prt (.getMessage e))
   (prt "에러를 받아서 좀 전에 뿌렸습니다."))
 (finally
  (println "아무리 그래도 마지막으로 이건 해야죠...")))

