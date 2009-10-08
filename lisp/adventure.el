;; -*- mode: lisp -*-
;; -*- coding: utf-8 -*-

(setq *objects* '(whiskey-bottle bucket frog chain))

(setq *gamemap* '((living-room (you are in the living-room of a wizards house - there is a wizard snoring loudly on the couch -)
                           (west door garden)
                           (upstairs stairway attic))
                          (garden (you are in a beautiful garden - there is a well in front of you -)
                           (east door living-room))
                          (attic (you are in the attic of the wizards house - there is a giant welding torch in the corner -)
                           (downstairs stairway living-room))))

(setq *object-locations* '((whiskey-bottle living-room)
                                   (bucket living-room)
                                   (chain garden)
                                   (frog garden)))

(setq *location* 'living-room)


(defun describe-location (location gamemap)
  (second (assoc location gamemap)))


(defun describe-path (path)
  `(there is a ,(second path) going ,(first path) from here -))

;; (describe-path (nth 2 (assoc 'living-room *gamemap*)))
;; (describe-path (nth 3 (assoc 'living-room *gamemap*)))

(defun describe-paths (location gamemap)
  (apply #'append (mapcar #'describe-path (cddr (assoc location gamemap)))))

;; (describe-paths 'living-room *gamemap*)
;; (describe-paths 'attic *gamemap*)
;; (describe-paths 'garden *gamemap*)

(defun is-at (obj loc obj-loc)
  (eq (second (assoc obj obj-loc)) loc))

;; (is-at 'whiskey-bottle 'living-room *object-locations*)
;; (is-at 'frog 'attic *object-locations*)

;; (defun describe-floor (loc objs obj-loc)
;;   (mapcar #'(lambda (o) (is-at o obj-loc)) objs))


(require 'cl)

(defun describe-floor (loc objs obj-loc)
  (apply #'append (mapcar (lambda (o)
                            `(you see a ,o on the floor -))
                          (remove-if-not (lambda (o)
                                           (is-at o loc obj-loc))
                                         objs))))


;; (describe-floor 'living-room *objects* *object-locations*)
;; (describe-floor 'attic *objects* *object-locations*)
;; (describe-floor 'garden *objects* *object-locations*)


(defun look ()
  (append (describe-location *location* *gamemap*)
          (describe-paths *location* *gamemap*)
          (describe-floor *location* *objects* *object-locations*)))

;; (look)


(defun walk-direction (direction)
  (let ((next (assoc direction (cddr (assoc *location* *gamemap*)))))
    (cond (next (setf *location* (third next))
                (look))
          (t `(you cannot go that way.)))))

;; (walk-direction 'upstairs)


(defmacro defspel (&rest more) `(defmacro ,@more))

(defspel walk (direction)
  `(walk-direction ',direction))

;; (walk west)


(defun pickup-object (object)
  (cond ((is-at object *location* *object-locations*)
         (push `(,object body) *object-locations*)
         `(you are now carrying the ,object))
        (t `(you cannot get that.))))

(defspel pickup (object)
  `(pickup-object ',object))


(defun dropdown-object (object)
  (cond ((is-at object 'body *object-locations*)
         (push `(,object ,*location*) *object-locations*)
         `(you dropped the ,object now.))
        (t `(you cannot drop that.))))

(defspel drop (object)
  `(dropdown-object ',object))



;; (pickup whiskey-bottle)
;; (drop whiskey-bottle)

(defun inventory ()
  (remove-if-not (lambda (o)
                   (is-at o 'body *object-locations*))
                 *objects*))

(defun have (object)
  (member object (inventory)))

;; (have 'bucket)


(setq *chain-welded* nil)
(setq *bucket-filled* nil)

(defspel game-action (command subj obj place &rest rest)
  `(defspel ,command (subject object)
     `(cond ((and (eq *location* ',',place)
                  (eq ',subject ',',subj)
                  (eq ',object ',',obj)
                  (have ',',subj))
             ,@',rest)
            (t '(i cant ,',command like that.)))))


(game-action weld chain bucket attic
             (cond ((and (have 'bucket) (setf *chain-welded* 't))
                    '(the chain is now securely welded to the bucket.))
                   (t '(you do not have a bucket.))))

(game-action dunk bucket well garden
             (cond (*chain-welded* (setf *bucket-filled* 't) '(the bucket is now full of water))
                   (t '(the water level is too low to reach.))))


(game-action splash bucket wizard living-room
             (cond ((not *bucket-filled*) '(the bucket has nothing in it.))
                   ((have 'frog) '(the wizard awakens and sees that you stole his frog.
                                   he is so upset he banishes you to the
                                   netherworlds- you lose! the end.))
                   (t '(the wizard awakens from his slumber and greets you warmly.
                        he hands you the magic low-carb donut- you win! the end.))))

;;----------------------------------------------------------------
;; vim: set ft=lisp
;;----------------------------------------------------------------

