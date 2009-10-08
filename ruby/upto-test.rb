#-*- coding: utf-8 -*-

def newline()
    print "\n"
end

for i in 1..10
  print i, " "
end
newline()

1.upto(10) {|i| print i, " "}
newline()

1.upto(12) {|i| print "2 x " + i.to_s + " = ", i * 2, "\n"}

5.downto(1) {|i| print i, " " }
newline()

5.downto(-5) {|i| print i, " " }
newline()
