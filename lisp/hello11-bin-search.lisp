;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(defun bin-search (item seq)
  (prt seq)
  (let ((len (length seq)))
    (if (or (zerop len)
            (< item (svref seq 0))
            (> item (svref seq (1- len))))
        nil
        (let ((mid (or (and (evenp len)
                            (1- (/ len 2)))
                       (1- (/ (1+ len) 2)))))
          (let ((mid-value (svref seq mid)))
            (if (equal item mid-value)
                (prt item)
                (if (< item mid-value)
                    (bin-search item (subseq seq 0 (1+ mid)))
                    (bin-search item (subseq seq (1+ mid))))))))))

(bin-search 10 #(0 1 2 3 4 5 6 7 8 9 10))
(bin-search 10 (list->array (range 20)))
(bin-search 100 (list->array (range 10)))

(let* ((seq (range 10))
       (arr (list->array seq)))
  (mapcar #'(lambda (x)
              (prt x)
              (bin-search x arr)
              (terpri))
          seq))


;; vim: set ft=lisp

