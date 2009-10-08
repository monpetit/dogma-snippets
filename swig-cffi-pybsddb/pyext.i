/* File : pyext.i */
%module pyext

%{
#include "pyext.h"
%}

/* Let's just grab the original header file here */
%include "pyext.h"
