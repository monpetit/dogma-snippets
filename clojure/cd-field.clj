
(def db {:a 1 :b 2 :c 3})
(println
 (db :a)
 (:c db)
 (db :x 'not-found)
 (db :b 'not-found)
 (db :A 'not-found)
 (db :B)
)


(defstruct cd-field
  :title
  :artist
  :rating
  :ripped)




(defn make-cd [title artist rating ripped]
  (struct-map cd-field :title title :artist artist :rating rating :ripped ripped))

(make-cd "핑계" "김건모" 7 true)
(make-cd "Roses" "Kathy Mattea" 7 true)
(make-cd "Fly" "Dixie Chicks" 8 false)
(make-cd "이오공감" "이오공감" 9 true)
(make-cd "친구여" "조용필" 9 true)
(make-cd "쌍쌍파티" "김추자" 6 false)
