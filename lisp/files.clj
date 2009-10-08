(import '(java.io FileReader BufferedReader))   
  
(def filedo)   
  
(defn fileread [fn f]   
    (let [fp (new BufferedReader (new FileReader fn))]   
        (filedo fp f)   
        (. fp close)   
    )   
  
)   
  
(defn filedo [fp f]   
    (loop [line (. fp readLine)]   
        (when (not (nil? line))   
            (f line)   
            (recur (. fp readLine))   
        )   
    )   
)   
  