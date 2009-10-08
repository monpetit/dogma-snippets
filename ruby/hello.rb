#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

str = <<'EOF'
This isn't a tab: \t
and this isn't a newline: \n
EOF
print str

str = <<-EOF
  Each of these lines
  starts with a pair
  of blank spaces.
EOF
print str


str = <<'ENDOFFILE'
우리는...
빛이 없는 어둠 속에서도 찾을 수 있는
ENDOFFILE
print str
