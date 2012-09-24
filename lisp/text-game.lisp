
;; (load "c:/work/dogma-snippets/lisp/dogma.lisp")

(defmacro test-prt (&body body)
  `(flet ((prts (&rest args)
            (mapcan #'(lambda (x) (princ x) (terpri)) args)))
     (prts
      ,@body)))

(defmacro defspel (&rest rest) `(defmacro ,@rest))

;;
;; ===============================================================
;;

(defparameter *nodes* '((living-room (you are in the living-room.
                                      a wizard is snoring loudly on the couch.))
                        (garden (you are in a beautiful garden.
                                 there is a well in front of you.))
                        (attic (you are in the attic.
                                there is a giant welding torch in the corner.))))

(defun describe-location (location nodes)
  (cadr (assoc location nodes)))

;; TEST...
(assoc 'garden *nodes*)
(describe-location 'living-room *nodes*)


(defparameter *edges* '((living-room (garden west door) (attic upstairs ladder))
                        (garden (living-room east door))
                        (attic (living-room downstairs ladder))))


(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

;; TEST...
;; (dm:prtln
(describe-path '(garden west door))
(describe-path (cadr (assoc 'attic *edges*)))
(cdr (assoc 'attic *edges*))
(cdr (assoc 'living-room *edges*))
(mapcar #'describe-path (cdr (assoc 'living-room *edges*)))
;; )

(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

;; TEST...
(describe-paths 'living-room *edges*)
(describe-paths 'garden *edges*)
(describe-paths 'attic *edges*)


(defparameter *objects* '(whiskey bucket frog chain))
(defparameter *object-locations* '((whiskey living-room)
                                   (bucket living-room)
                                   (chain garden)
                                   (frog garden)))

(defun objects-at (loc objs obj-locs)
  (flet ((at-loc-p (obj)
           (eq (cadr (assoc obj obj-locs)) loc)))
    (remove-if-not #'at-loc-p objs)))

;; TEST...
(objects-at 'living-room *objects* *object-locations*)


(defun describe-objects (loc objs obj-loc)
  (flet ((describe-obj (obj)
           `(you see a ,obj on the floor.)))
    (apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))

;; TEST...
(test-prt
  (describe-objects 'living-room *objects* *object-locations*)
  (describe-objects 'garden *objects* *object-locations*)
  (describe-objects 'attic *objects* *object-locations*))

(defparameter *location* 'living-room)

(defun look ()
  (append (describe-location *location* *nodes*)
          (describe-paths *location* *edges*)
          (describe-objects *location* *objects* *object-locations*)))

;; TEST...
(test-prt (look))
(assoc *location* *edges*)

(defun walk (direction)
  (let ((next (find direction
                    (cdr (assoc *location* *edges*))
                    :key #'cadr)))
    (if next
        (progn
          (setf *location* (car next)) ;; new location
          (look))
        '(you cannot go thay way.))))

;; (defspel walk (direction)
;;   `(walk-direction ',direction))


(defun pickup (object)
  (cond ((member object
                 (objects-at *location* *objects* *object-locations*))
         (push (list object 'body) *object-locations*)
         `(you are now carring the ,object))
        (t '(you cannot get that.))))

;; (defspel pickup (object)
;;   `(pickup-object ',object))

(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))

(defun say-hello ()
  (princ "Please type your name:")
  (let ((name (read)))
    (princ "Nice to meet you, ")
    (princ name)))

(defun game-repl ()
  (let ((cmd (game-read)))
    (unless (eq (car cmd) 'quit)
      (game-print (game-eval cmd))
      (game-repl))))

(defun game-read ()
  (let ((cmd (read-from-string
              (concatenate 'string "(" (read-line) ")"))))
    (flet ((quote-it (x)
             (list 'quote x)))
      (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

(defparameter *allowed-commands* '(look walk pickup inventory))

(defun game-eval (sexp)
  (if (member (car sexp) *allowed-commands*)
      (eval sexp)
      '(i do not know that command.)))


(defun tweak-text (lst caps lit)
  (when lst
    (let ((item (car lst))
          (rest (cdr lst)))
      (cond ((eql item #\space) (cons item (tweak-text rest caps lit)))
            ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
            ((eql item #\") (tweak-text rest caps (not lit)))
            (lit (cons item (tweak-text rest nil lit)))
            (caps (cons (char-upcase item) (tweak-text rest nil lit)))
            (t (cons (char-downcase item) (tweak-text rest nil nil)))))))


(defun game-print (lst)
  (princ (coerce (tweak-text (coerce (string-trim "() "
                                                  (prin1-to-string lst))
                                     'list)
                             t
                             nil)
                 'string))
  (fresh-line))
