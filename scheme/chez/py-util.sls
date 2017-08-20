#|
(define path% (getenv "PATH"))
(putenv "PATH" (string-append
                 "C:\\dev\\Python36;"
                 "C:\\dev\\Python36\\Scripts;"
                 path%))
|#

(library (py-util)
  (export
    py-init
    py-exit
    py-run-string
    py-mem-free)
  (import (chezscheme))

  (define no-op (load-shared-object "Python36.dll"))

  (define py-init (foreign-procedure "Py_Initialize" () void))
  (define py-exit (foreign-procedure "Py_FinalizeEx" () int))
  (define py-run-string (foreign-procedure "PyRun_SimpleString" (string) int))
  (define py-mem-free (foreign-procedure "PyMem_Free" (void*) void))

  ) ;; library

;; vim: set filetype=scheme :

