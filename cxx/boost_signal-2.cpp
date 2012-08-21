#include <iostream>
#include <ostream>
#include <thread>
#include <atomic>

#include <windows.h>

using namespace std;

#include <boost/signals2/signal.hpp>

void running(int count)
{
    for (int i = 0; i < count; i++) {
        std::cout << "running... " << i << std::endl;
        Sleep(30);
    }
}


int main(int argc, char *argv[])
{
    boost::signals2::signal<void (int)> sig;
    sig.connect(&running);

    for (int i = 3; i < 10; i++) {
        sig(i);
        std::cout << "hello" << std::endl;
    }

    return 0;
}

