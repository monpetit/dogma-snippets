;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f
;; then enter the text in that file's own buffer.

(import '(monpetit Petit))

(let [oos (java.io.ObjectOutputStream. (java.io.FileOutputStream. "c:/work/clojure/output.tmp"))]
  (.writeInt oos 12345)
  (.writeObject oos (java.util.ArrayList. (seq "오늘 하루는 어떻게 지냈나요?")))
  (.writeObject oos (str "오늘"))
  (.writeBoolean oos true)
  (.writeObject oos (java.util.Date. ))
  (.writeObject oos (java.util.ArrayList. (range 10)))
  (.writeObject oos (new Petit))
  (.writeObject oos (java.util.HashMap. {'이름 '도그마 '나이 23}))
  (.close oos))


(let [ois (java.io.ObjectInputStream. (java.io.FileInputStream. "c:/work/clojure/output.tmp"))]
  (prt (.readInt ois))
  (prn (apply str (seq (.readObject ois))))
  (prt (.readObject ois))
  (prt (.readBoolean ois))
  (prt (type (.readObject ois)))
  (prt (rotate (seq (.readObject ois))))
  (let [person (.readObject ois)]
    (prt (.name person) (.age person) (type person)))
  (prt (.readObject ois))
)


