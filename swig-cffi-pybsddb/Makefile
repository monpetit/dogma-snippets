
SWIG=c:/develop/swigwin-1.3.40/swig.exe
CFLAGS=-O2 -s -shared -pipe -Ic:/develop/python26/include
LDFLAGS=-lpython26 -Lc:/develop/python26/libs

all: pyext.dll


pyext.dll: pyext.c pyext.i pyext.h
	$(SWIG) -cffi pyext.i
	sed	-e 's/py_init)/py-init)/g' \
		-e 's/py_close)/py-close)/g' \
		-e 's/py_runstr)/py-runstr)/g' \
		-e 's/py_none)/py-none)/g' \
		-e 's/null_pointer)/null-pointer)/g' \
		-e 's/bdb_module)/bdb-module)/g' \
		-e 's/db_open)/db-open)/g' \
		-e 's/db_close)/db-close)/g' \
		-e 's/db_size)/db-size)/g' \
		-e 's/db_store)/db-store)/g' \
		-e 's/db_sync)/db-sync)/g' \
		-e 's/db_clear)/db-clear)/g' \
		-e 's/db_first_item)/db-first-item)/g' \
		-e 's/db_last_item)/db-last-item)/g' \
		-e 's/tuple_key)/tuple-key)/g' \
		-e 's/tuple_value)/tuple-value)/g' \
		-e 's/db_next_item)/db-next-item)/g' \
		-e 's/db_prev_item)/db-prev-item)/g' \
		-e 's/db_get)/db-get)/g' \
		-e 's/has_key)/has-key)/g' \
		-e 's/db_del)/db-del)/g' \
		-e 's/db_iterkeys)/db-iterkeys)/g' \
		-e 's/db_itervalues)/db-itervalues)/g' \
		-e 's/db_iteritems)/db-iteritems)/g' \
		-e 's/iter_next)/iter-next)/g' \
		pyext.lisp > pyext.lisp.out
	mv -f pyext.lisp.out pyext.lisp
	gcc $(CFLAGS) -o $@ $< $(LDFLAGS)
	
