// shared_ptr.cpp : Defines the entry point for the console application.
//

#define BOOST_ALL_DYN_LINK 1

#include <stdio.h>
#include <boost/shared_ptr.hpp>
#include <boost/shared_array.hpp>
#include <string>
#include <iostream>
#include <memory>
#include <list>
#include <queue>
#include <cstring>

#include <boost/dynamic_bitset.hpp>
#include <bitset>

#include <boost/chrono.hpp>
#include <boost/thread.hpp>
#include <boost/date_time.hpp>

#include <windows.h>


using namespace std;"


struct Fruit
{
public:
    Fruit(const string & fruit_name) : name(fruit_name) {
        cout << name << " 생성됨!" << endl;
    }
    ~Fruit() {
        cout << name << " 소멸됨!" << endl;
    }

    const string get_name(void) const {
        return name;
    }

private:
    const string name;
};


typedef boost::shared_ptr<Fruit> fruit_ptr;
typedef std::list<fruit_ptr> fruit_ptr_array_t;


fruit_ptr new_fruit(const string & fruit_name)
{
    return fruit_ptr(new Fruit(fruit_name));
}


#define CORE_COUNT 8

/// dynamic_bitset 테스트...
void test_dynamic_bitset(void)
{
    boost::dynamic_bitset<> core_mask1(CORE_COUNT);
    boost::dynamic_bitset<> core_mask2(CORE_COUNT);

    core_mask1[7] = 1;
    core_mask1[6] = 1;
    core_mask1[5] = 1;
    core_mask2[0] = 1;

    boost::dynamic_bitset<> core_mask3 = core_mask1 | core_mask2;

    std::cout << "CPU CORE MASK 1 = " << core_mask1 << std::endl;
    std::cout << "CPU CORE MASK 2 = " << core_mask2 << std::endl;
    std::cout << "CPU CORE MASK 3 = " << core_mask3 << std::endl;
    std::cout << "CPU CORE MASK 3 (value) = " << core_mask3.to_ulong() << std::endl;

    std::bitset<CORE_COUNT> core_mask4;
    core_mask4[2] = 1;
    core_mask4[4] = 1;
    core_mask4[7] = 1;

    std::bitset<CORE_COUNT> core_mask5;
    core_mask5[1] = 1;

    std::bitset<CORE_COUNT> core_mask6 = core_mask4 | core_mask5;

    std::cout << "CPU CORE MASK 4 = " << core_mask4 << std::endl;
    std::cout << "CPU CORE MASK 4 (value) = " << core_mask4.to_ulong() << std::endl;
    std::cout << "CPU CORE MASK 5 = " << core_mask5 << std::endl;
    std::cout << "CPU CORE MASK 6 = " << core_mask6 << std::endl;    
}


void test_lambda(void)
{
    auto func = [](int n) { std::cout << "\tNumber = " << n << std::endl; };
    func(3333);
    func(-3930);
}

class Car
{
public:
#if 0
    Car() {
        std::cout << "[CAR:" << sn << "] " << name << " 생성됨!" << std::endl;
    }
#endif
    Car(int _sn, const string & _name) : sn(_sn), name(_name), raw_buffer(NULL) {
        std::cout << "[CAR:" << sn << "] " << name << " 생성됨!" << std::endl;
        buffer = boost::shared_array<char> (new char[1024]);
        strncpy(buffer.get(), name.data(), name.length());
        
        raw_buffer = new char[10240];
    }

    ~Car() {
        delete [] raw_buffer;
        std::cout << "[CAR:" << sn << "] " << name << " 소멸됨!" << std::endl;        
    }


#if 0
    Car &operator =(const Car &other) {
        name = std::string("+") + other.get_name();
        sn = other.get_sn();

        buffer = boost::shared_array<char> (new char[1024]);
        strncpy(buffer.get(), name.data(), name.length());

        return *this;
    }

    bool operator == (const Car &other) const {
        return (sn == other.sn);
    }

    bool operator < (const Car &other) const {
        return (sn < other.sn);
    }

    bool operator > (const Car &other) const {
        return (sn > other.sn);
    }
#endif

    const string get_name(void) const {
        return name;
    }

    const int get_sn(void) const {
        return sn;
    }

    void show_name() {
        std::cout << buffer.get() << std::endl;
    }

private:
    int sn;
    string name;
    boost::shared_array<char> buffer;
    char* raw_buffer;    
};

typedef boost::shared_ptr<Car> car_ptr;

car_ptr new_car(int sn, const string & name)
{
    return car_ptr(new Car(sn, name));
}


struct greater_car_ptr : public std::binary_function <car_ptr, car_ptr, bool>
{
    bool operator () (const car_ptr & _left, const car_ptr & _right) const {
        return (_left->get_sn() > _right->get_sn());
    }
};


void test_pqueue(void)
{
#if 1
    std::priority_queue<car_ptr, std::vector<car_ptr>, greater_car_ptr > cqueue;
        
    cqueue.push(new_car(3, "캠리"));
    cqueue.push(new_car(0, "르망"));
    cqueue.push(new_car(2, "아반떼"));    
    cqueue.push(new_car(4, "그랜져"));
    cqueue.push(new_car(1, "포니"));
    cqueue.push(new_car(-31, "레간자"));
    cqueue.push(new_car(5, "에쿠스"));
    
    
#else
    std::priority_queue<Car, std::vector<Car>, std::greater<Car> > cqueue;

    cqueue.push(Car(3, "캠리"));
    cqueue.push(Car(2, "아반떼"));
    cqueue.push(Car(4, "그랜져"));
    cqueue.push(Car(1, "포니"));
    cqueue.push(Car(5, "에쿠스"));
    cqueue.push(Car(0, "르망"));
#endif

    std::cout << std::endl;

    while (!cqueue.empty()) {        
        std::cout << cqueue.top()->get_sn() << "\t" << cqueue.top()->get_name() << "\t";
        cqueue.top()->show_name();
        cqueue.pop();
    }

#if 0
    std::priority_queue<int, std::vector<int>, std::greater<int> > mq;

    mq.push(1);
    mq.push(3);
    mq.push(2);
    mq.push(4);
    mq.push(0);
    mq.push(-3);
    mq.push(7);

    while (!mq.empty()) {
        std::cout << mq.top() << std::endl;
        mq.pop();
    }
#endif


}


void sleep_test()
{    
    for (int i = 0; i < 1000; i++) {
        boost::chrono::system_clock::time_point start = boost::chrono::system_clock::now();
        boost::this_thread::sleep_for(boost::chrono::nanoseconds(1600000));
        boost::chrono::nanoseconds sec  = boost::chrono::system_clock::now() - start;
        // boost::chrono::duration<double> sec = boost::chrono::system_clock::now() - start;
        std::cout << "took " << sec.count() << " seconds\n";
    }
}


///////////////////////////////////////////////////////

typedef NTSTATUS (WINAPI *LPNTDELAYEXECUTION)(BOOLEAN, PLARGE_INTEGER);

bool gimme_native()
{
    LPNTDELAYEXECUTION delay_exec;
    HMODULE obsolete = GetModuleHandle(L"ntdll.dll");
    // *(FARPROC*)&
    if (obsolete != NULL) {
        delay_exec = (LPNTDELAYEXECUTION)GetProcAddress(obsolete, "NtDelayExecution");

        if (delay_exec != NULL) {
            LARGE_INTEGER interval;
            interval.QuadPart = - 12000;


            for (int i = 0; i < 1000; i++) {
                boost::chrono::system_clock::time_point start = boost::chrono::system_clock::now();

                NTSTATUS result = delay_exec(FALSE, &interval);

                boost::chrono::nanoseconds sec  = boost::chrono::system_clock::now() - start;
                // boost::chrono::duration<double> sec = boost::chrono::system_clock::now() - start;
                std::cout << "took " << sec.count() << " seconds\n";
            }            
        }
    }

    return true;
}






////////////////////////////////////////////////////////

    
int main(int argc, char* argv[])
{
#if 0
    fruit_ptr_array_t frarr;
    fruit_ptr s = fruit_ptr(new Fruit("Apple"));

    frarr.push_back(new_fruit("pear"));
    frarr.push_back(new_fruit("banana"));
    frarr.push_front(new_fruit("kiwi"));
    frarr.push_back(new_fruit("오이"));
    frarr.push_back(s);

    cout << endl << endl;

    cout << s->get_name() << endl;
    frarr.pop_front();
    fruit_ptr p = frarr.front();
    cout << p->get_name() << endl;
    frarr.pop_front();
    p = frarr.front();
    cout << p->get_name() << endl;

    cout << endl << endl;
#endif

    test_dynamic_bitset();
    test_lambda();
    test_pqueue();

    // sleep_test();

    gimme_native();

    return 0;
}

