;; -*- mode: clojure -*-
;; -*- coding: utf-8 -*-


(use '[clojure.contrib.sql :as sql])

(let [db-path "c:/work/clojure/myblog"]

  (def db {:classname "org.apache.derby.jdbc.EmbeddedDriver"
           :subprotocol "derby"
           :subname db-path
           :create true}))

(defn create-blogs
  "Create a table to store blog entries"
  []
  (clojure.contrib.sql/create-table
   :blogs
   [:id :int "PRIMARY KEY" "GENERATED ALWAYS AS IDENTITY"]
   [:title "varchar(255)"]
   [:body :clob]
   [:created_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]))



(clojure.contrib.sql/with-connection
  db
  (clojure.contrib.sql/transaction
   (create-blogs)))

(defn insert-blog-entry
  "Insert data into the table"
  [title,body]
  (clojure.contrib.sql/insert-values
   :blogs
   [:title :body]
   [title body]))


(clojure.contrib.sql/with-connection
  db
  (clojure.contrib.sql/transaction
   (insert-blog-entry "안녕 블라디미르" "리스프 월드가 그렇지 뭐...") ))

(with-connection db
  (with-query-results rs ["select * from blogs"]
                                        ; rs will be a sequence of maps
                                        ; one for each record in the result set.
    (dorun (map #(println (:title %)) rs))))

(with-connection db
  (with-query-results rs ["select * from blogs"]
                                        ; rs will be a sequence of maps
                                        ; one for each record in the result set.
    (dorun (map println rs))))



(defn update-blog
  "This method updates a blog entry"
  [id attribute-map]
  (clojure.contrib.sql/update-values
   :blogs
   ["id=?" id]
   attribute-map))



(with-connection db
  (clojure.contrib.sql/transaction
   (update-blog 1 {:title "Awesome Title" :body "돈 오백원이 어디냐고..."})))


(with-connection db
  (with-query-results rs ["select * from blogs"]
    (doseq [row rs]
      (let [body (:body row)
            len (.length body)]
        (prt (.getSubString body 1 (+ len 1)))))))

(defn delete-blog
  "Deletes a blog entry given the id"
  [id]
  (clojure.contrib.sql/with-connection db
    (clojure.contrib.sql/delete-rows :blogs ["id=?" id])))

(delete-blog 1)


(defn drop-blogs
  "Drop the blogs table"
  []
  (try
   (clojure.contrib.sql/drop-table :blogs)
   (catch Exception _)))



(clojure.contrib.sql/with-connection
  db
  (clojure.contrib.sql/transaction
   (drop-blogs)))


;; vim: set ft=clojure