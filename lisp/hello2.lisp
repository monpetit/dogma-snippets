
(defparameter 변수 '(기미년 3월 1일 정오 터지자 밀물 같은 대한독립 만세))
(apply #'prt 변수)
(apply #'println 변수)
(mapcar #'println 변수)
(maplist #'println 변수)

