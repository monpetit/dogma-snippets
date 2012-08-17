
#include <iostream>
#include <string>
#include <deque>
#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>

enum species_t {
    s_dog   = 1000,
    s_cat,
    s_hipo,
    s_lion,
    s_tiger
};

class animal : private boost::noncopyable
{
public:
    animal() {}
    animal(std::string _name) : name(_name) {}
    animal(int _age) : age(_age) {}
    animal(std::string _name, int _age) : name(_name), age(_age) {}
    ~animal() {
        std::cout << "[ANIMAL] " << get_name() << " 소멸!" << std::endl;
    }

    std::string get_name() {
        return name;
    }

    int get_age() {
        return age;
    }

    species_t get_species() {
        return species;
    }

    void set_species(species_t sp) {
        this->species = sp;
    }

private:
    std::string name;
    int age;
    species_t species;
};

class dog : public animal
{
public:
    dog() : animal() {
        set_species(s_dog);
    }
    dog(std::string _name) : animal(_name) {
        set_species(s_dog);
    }
    dog(int _age) : animal(_age) {
        set_species(s_dog);
    }
    dog(std::string _name, int _age) : animal(_name, _age) {
        set_species(s_dog);
    }
    virtual ~dog() {
        std::cout << "[DOG] " << this->get_name() << " 소멸!" << std::endl;
    }
};

typedef boost::shared_ptr<dog> dog_ptr;
typedef std::deque<dog*> dog_list_t;
typedef std::deque<dog_ptr> dog_ptr_array_t;


int main(void)
{
    animal a(std::string("아름이"));
    dog d(std::string("쫑"), 3);

    dog_ptr d2(new dog("메리", 2));
    dog_ptr d3 = d2;
    dog_ptr d4(d2);
    // dog_ptr d4 = dog_ptr(&d);

    dog_list_t dogarr;

    std::cout << "hello vladimir" << std::endl;
    std::cout << a.get_name() << std::endl;
    std::cout << d.get_age() << std::endl;
    std::cout << d2->get_name() << std::endl;
    std::cout << d3->get_name() << std::endl;
    std::cout << d4->get_name() << std::endl;

    dogarr.push_back(&d);
    dogarr.push_back(d2.get());
    dogarr.push_back(d3.get());
    dogarr.push_back(d4.get());

    std::cout << "------" << std::endl;
    for (int i = 0; i < dogarr.size(); i++)
        std::cout << dogarr[i]->get_name() << std::endl;
    std::cout << "------" << std::endl;

    dog_ptr_array_t dogs;
    dogs.push_back(d2);
    dogs.push_back(d3);
    dogs.push_back(d4);
    dogs.push_back(dog_ptr(new dog("방울이", 1)));

    while (!dogs.empty()) {
        dog_ptr ddd = dogs.front();
        std::cout << "[ARRAY] " << ddd->get_name() << ", " << ddd->get_age() << ", " << ddd->get_species() << std::endl;
        dogs.pop_front();
    }
    std::cout << "------" << std::endl;



    return 0;
}
