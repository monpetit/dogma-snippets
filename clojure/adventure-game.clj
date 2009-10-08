
(use 'clojure.contrib.str-utils)

(defn convert-to-symbol [strn]
  (map symbol (re-split #" " strn)))



;;;;;;;;;;;;;;;;;

(def objects '(whiskey-bottle bucket frog chain))

(def world-map {:living-room '((you are in the living room
				    of a wizards house - there is a wizard
				    snoring loudly on the couch -)
			       (west door garden)
			       (upstairs stairway attic))
		:garden '((you are in a beautiful garden -
			       there is a well in front of you -)
			  (east door living-room))
		:attic '((you are in the attic of the
			      wizards house - there is a giant
			      welding torch in the corner -)
			 (downstairs stairway living-room))})


(def object-locations '((whiskey-bottle :living-rooom)
			(bucket :living-room)
			(frog :garden)
			(chain :gargen)))


(defn describe-location [location gamemap]
  (first (location gamemap)))


;; (describe-location :living-room world-map)
;; (describe-location :garden world-map)



(defn describe-path [path]
  (concat '(there is a) (list (second path) 'going (first path)) '(from here -)))


;; (describe-path (nth (:living-room world-map) 2))

(defn describe-paths [location gamemap]
  (apply concat
	 (map describe-path
	      (rest (location gamemap)))))

;;(describe-paths :living-room world-map)




