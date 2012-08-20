//-*- mode: c++ -*-
//-*- coding: utf-8 -*-

#include <iostream>
#include <cstdlib>
#include <cstring>

using namespace std;


void alloc_memory(int** pptr)
{
    *pptr = (int*) calloc(1, sizeof(int));
    **pptr = 30;
    cout << "*pptr = " << *pptr << endl;
    cout << "**pptr = " << **pptr << endl;
}


// BAD CODE!!!
void alloc_memory2(int* ptr)
{
    ptr = (int*) calloc(1, sizeof(int));
    *ptr = 4330;
    cout << "ptr = " << ptr << endl;
    cout << "*ptr = " << *ptr << endl;
}


void free_memory(int** pptr)
{
    free(*pptr);
}


int main(int argc, char* argv[])
{
    int* ptr = NULL;
    alloc_memory(&ptr);

    *ptr = -3020;

    int* ptr2 = NULL;
    alloc_memory(&ptr2);

    *ptr2 = -30930;

    free_memory(&ptr);
    free_memory(&ptr2);

    return 0;
}

// vim: set ts=8 sts=4 sw=4 ft=c et:

