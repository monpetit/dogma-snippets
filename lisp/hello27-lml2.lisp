
#+sbcl (require :lml2)
#-sbcl (asdf-require :lml2)

(import  'dm:prt)

(defun header ()
  (lml2:html
   (:head
    (:title "LML2 README")
    ((:meta :http-equiv "Content-Type" :content "text/html; charset=utf-8"))
    ((:meta :name "Copyright" :content "Kevin Rosenberg 2002 <kevin@rosenberg.net>"))
    ((:meta :name "description" :content "Lisp Markup Language Documentation"))
    ((:meta :name "author" :content "Kevin Rosenberg"))
    ((:meta :name "keywords" :content "Common Lisp, HTML, Markup Langauge")))))

(defun petit (n)
  (dotimes (i n)
    (lml2:html (:p (:i "안녕 블라디미르")))))

(lml2:html
  (:html
 (header)
 (:body
  (:p
   (:i "무엇이 나올까요?")
   (petit 3)
   (:br)
   (dotimes (i 10)
     (prt 'hello i)
     (lml2:html (:br)))))))

