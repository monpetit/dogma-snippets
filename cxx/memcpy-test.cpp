//-*- mode: c++ -*-
//-*- coding: utf-8 -*-

#include <QTime>

#include <iostream>
#include <cstdlib>
#include <string>

using namespace std;

#define SAFE_DELETE_ARRAY(X) { \
    if (X) { \
        delete[] X; \
        X = NULL; \
    } \
    }


typedef char* char_array;

const size_t width = 2048 * 2;  // 4K
const size_t height = 1080 * 2; // 4K
const size_t channels = 4;      // RGBA


int main(int, char*)
{
    char_array src, dest;
    size_t length = width * height * channels * sizeof(char);
	size_t image_size = (width / 2) * (height / 2) * channels * sizeof(char);

    QTime timer;
    timer.start();

    src = new char[length];
    dest = new char[length];
    int elapsed = timer.elapsed();
    cout << "elapsed time for allocation: " << elapsed << endl;
    timer.restart();

    for (int i = 0; i < 30; i++) {
        memcpy(dest, src, image_size);
        elapsed = timer.elapsed();
        cout << i << "\telapsed time for memcpy: " << elapsed << endl;
        timer.restart();
    }

    SAFE_DELETE_ARRAY(src)
    SAFE_DELETE_ARRAY(dest)

    elapsed = timer.elapsed();
    cout << "elapsed time for delete array: " << elapsed << endl;

    return 0;
}

// vim: set ts=8 sts=4 sw=4 ft=c et:
