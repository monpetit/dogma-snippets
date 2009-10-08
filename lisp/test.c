#define DllExport  __declspec(dllexport)
#include "windows.h"
DllExport int test_fun(int foo)
{
        return foo + 101;
}

