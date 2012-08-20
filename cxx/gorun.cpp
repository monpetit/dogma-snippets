/*-*- mode: c -*-*/
/*-*- coding: utf-8 -*-*/

#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include <Python.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
// #include <wctype.h>

const char command[] = ""
                       "from subprocess import *\n"
                       "import sys\n"
                       "\n"
                       "cmd = ['go', 'run']\n"
                       "#print(sys.argv)\n"
                       "p = Popen(cmd + sys.argv[1:], shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)\n"
                       "print(p.stdout.readall().decode('utf-8'))\n";


wchar_t* char_to_wchar(const char* pstrSrc)
{
    assert(pstrSrc);
    int nLen = strlen(pstrSrc)+1;

    wchar_t* pwstr = (LPWSTR) malloc ( sizeof( wchar_t )* nLen);
    mbstowcs(pwstr, pstrSrc, nLen);

    return pwstr;
}

int main(int argc, char* argv[])
{
    Py_Initialize();

    wchar_t** args = (wchar_t**) calloc(argc, sizeof(wchar_t*));
    int i;
    for (i = 0; i < argc; i++)
        args[i] = char_to_wchar(argv[i]);

    PySys_SetArgv(argc, args);
    PyRun_SimpleString(command);
    Py_Finalize();

    for (i = 0; i < argc; i++)
        free(args[i]);
    free(args);

    return 0;
}

/* vim: set ts=8 sts=4 sw=4 ft=c et: */

