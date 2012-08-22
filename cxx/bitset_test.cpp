// bitset_test.cpp : Defines the entry point for the console application.
//

#include <iostream>
#include <cstring>
#include <boost/dynamic_bitset.hpp>


unsigned long mask_bitset(const std::string mask_string)
{
    size_t length = mask_string.length();
    boost::dynamic_bitset<> cpumask(length);
    const char* mask_cstring = mask_string.c_str();

    for (int i = 0; i < length; i++)
        cpumask[length - i - 1] = mask_cstring[i] - '0';

    return cpumask.to_ulong();
}


void test_mask(const std::string mstr)
{
    std::cout << mstr << "\t" << mask_bitset(mstr) << std::endl;
}


int main(int argc, char* argv[])
{
    std::cout << mask_bitset("001000011111") << std::endl;

    test_mask("011000000000");
    test_mask("100000000000");
    test_mask("001111111111");

    test_mask("01110000");
    test_mask("10000000");
    test_mask("00111111");

    test_mask("110000");
    test_mask("110000");
    test_mask("011111");

    test_mask("1100");
    test_mask("1100");
    test_mask("0111");

    return 0;
}

