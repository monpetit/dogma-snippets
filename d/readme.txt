[example.d]
import python24;
import std.c.stdio;

extern (C) PyObject *
ex_foo(PyObject *self, PyObject *args)
{
	printf("Hello, world\n");
	Py_INCREF(Py_None);
	return Py_None;
}

PyMethodDef[] example_methods = [
	{"foo", &ex_foo, 1, "foo() doc string"},
	{ null, null, 0, null }
];

export extern (C)
void
initexample()
{
	Py_InitModule("example", example_methods);
}
// EOF

I also have a python24.lib created with implib:

C:>implib /system python24.lib c:\windows\system32\python24.dll

Finally, I have an example.def:

[example.def]
LIBRARY "example.lib"
EXETYPE NT
SUBSYSTEM WINDOWS,5.0
CODE PRELOAD DISCARDABLE SHARED EXECUTE
DATA PRELOAD SINGLE WRITE

The DLL is compiled with:

C:>dmd -ofexample.dll dll.d example.d python24.d python24.lib example.def

The example.dll is generated. I then start a python session and do the 
following:
