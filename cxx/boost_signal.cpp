#include <iostream>
#include <ostream>

using namespace std;

#include <boost/signals2/signal.hpp>

struct Hello
{
  void operator()() const
  {
    std::cout << "Hello";
  }
};

struct World
{
  void operator()() const
  {
    std::cout << ", World!" << std::endl;
  }
};

struct GoodMorning
{
  void operator()() const
  {
    std::cout << "... and good morning!" << std::endl;
  }
};



int main(int argc, char *argv[])
{
  boost::signals2::signal<void ()> sig;

  sig.connect(1, World());  // connect with group 1
  sig.connect(0, Hello());  // connect with group 0


  // by default slots are connected at the end of the slot list
  sig.connect(GoodMorning());

  // slots are invoked this order:
  // 1) ungrouped slots connected with boost::signals2::at_front
  // 2) grouped slots according to ordering of their groups
  // 3) ungrouped slots connected with boost::signals2::at_back
  sig();


	return 0;
}
