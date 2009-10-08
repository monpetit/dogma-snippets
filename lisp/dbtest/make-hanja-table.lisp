
(asdf-require :cl-utilities)

(with-open-file (stream "c:/work/lisp/dbtest/hanja-dict.txt"
                        :direction :input)
  (let ((*hanja-table* (make-hash-table)))
    (do ((line (read-line stream nil 'eof)
               (read-line stream nil 'eof)))
        ((eq line 'eof) 'done)
      (let ((data (cl-utilities:split-sequence #\: line)))
        (let ((hanja (intern (car data)))
              (noun (intern (nth 1 data)))
              (meaning (nth 2 data)))
          (setf (gethash hanja *hanja-table*) (cons noun meaning)))))
    (with-open-file (outbuf "c:/work/lisp/dbtest/hanja-table.tbl"
                            :direction :output :if-exists :supersede)
      (maphash #'(lambda (k v)
                   (format outbuf "~s~%" (cons k v)))
               *hanja-table*))))
