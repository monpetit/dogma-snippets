
(library (semidbm)
  (export
    py-sdbm-init
    py-sdbm-open
    py-sdbm-close!
    py-sdbm-count
    py-sdbm-sync!
    py-sdbm-compact!
    py-sdbm-get
    py-sdbm-store!
    py-sdbm-iterkeys
    py-sdbm-nextkey
    py-sdbm-keys
    py-sdbm-values
    py-sdbm-pairs
    py-sdbm-nextpair)
  (import (chezscheme))

  (define no-op
    (let ((libpath (getenv "CHEZSCHEMELIBDIRS")))
      (load-shared-object (string-append libpath "/semidbm/python_semidbm.pyd"))))

  (include "semidbm/semidbm.scm")

  ) ;; library

;; vim: set filetype=scheme :
