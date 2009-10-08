
(imports '(dm:prt dm:range))

(sb-alien:load-shared-object "test.dll")
(sb-alien:define-alien-routine "test_fun" int
  (i int))

(loop for x from 0 to 1000
     do (prt (test-fun x)))

(dolist (x (range 100))
  (prt x '---> (test-fun x)))