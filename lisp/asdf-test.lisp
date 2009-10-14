
(mapcar #'(lambda (path)
            (pushnew path asdf:*central-registry*))
        (directory
         (merge-pathnames ".sbcl/systems/*/" (user-homedir-pathname))))
