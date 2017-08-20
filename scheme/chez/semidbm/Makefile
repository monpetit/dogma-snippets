
CFLAGS += -fno-strict-aliasing -march=x86-64 -mtune=generic -O2 -pipe -fwrapv -D__USE_MINGW_ANSI_STDIO=1 -DNDEBUG

all: python_semidbm.pyd

python_semidbm.pyd: python_semidbm.c
	gcc -IC:/dev/Python36/include $(CFLAGS) -c python_semidbm.c
	gcc -shared -Wl,--export-all-symbols -o python_semidbm.pyd python_semidbm.o -lpython36 -LC:/dev/Python36/libs

python_semidbm.c: python_semidbm.pyx
	cython -a -3 python_semidbm.pyx

clean:
	rm -f *.pyd *.o

