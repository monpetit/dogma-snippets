(defun permutations (items &aux result)
   (if items
       (dolist (item items result)
        (dolist (permutation (permutations (remove item items)))
          (push (cons item permutation) result)))
       '(nil))) 

;; (mapcar #'prt (permutations (range 3)))

(defun p (l)
  (if (null l) '(())
  (mapcan #'(lambda (x)
    (mapcar #'(lambda (y) (cons x y))
      (p (remove x l :count 1)))) l)))

;; (mapcar #'prt (p (range 3)))

(prt (p '(a b c d)))
