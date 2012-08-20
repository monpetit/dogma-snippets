

import sys

for line in open(sys.argv[1], 'rt'):
    buffer = line.strip()
    print ('scm_c_define("%s", scm_from_int(%s));' % (buffer, buffer))


