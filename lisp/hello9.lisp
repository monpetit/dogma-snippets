;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-



(defun shortest-path (start end net)
  (bfs end (list (list start)) net))

(defun bfs (end queue net)
  (if (null queue)
      nil
      (let ((path (car queue)))
        (let ((node (car path)))
          (if (eql node end)
              (reverse path)
              (bfs end
                   (append (cdr queue)
                           (new-paths path node net))
                   net))))))


(defun new-paths (path node net)
  (mapcar #'(lambda (n)
              (cons n path))
          (cdr (assoc node net))))



(let ((min '((a b c) (b c) (c d))))
  (println
    min
    (shortest-path 'a 'd min)))

;; vim: set ft=lisp

