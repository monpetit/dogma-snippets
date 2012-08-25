
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <errno.h>

#include <iconv.h>
#include <boost/shared_array.hpp>


#ifndef USE_SHARED_ARRAY
#define USE_SHARED_ARRAY    1
#endif

#ifndef TEST_MODE
#define TEST_MODE           0
#endif


std::string conv_str(std::string src_str,
                        const char* to_code,
                        const char* from_code)
{
    std::string result_str("");

    if (src_str.length() == 0)
        return result_str;

    iconv_t cd = iconv_open(to_code, from_code);
    if (cd == (iconv_t)(-1)) {
        perror("iconv_open");
        return result_str;
    }

    char* src = (char*)src_str.data();
    size_t src_len = src_str.length();
    size_t dest_len = (src_len * 4) + 1;

#if USE_SHARED_ARRAY
    boost::shared_array<char> dest_buffer = boost::shared_array<char> (new char[dest_len]);
    char* dest = dest_buffer.get();
    memset(dest, 0, dest_len * sizeof(char));
#else
    char* dest = (char*) calloc(dest_len, sizeof(char));
#endif
    char* saved_dest = dest;    // save start pointer of dest buffer 

#if TEST_MODE
    puts(src);
    printf("length of src = %d\n", src_len);
    printf("length of dest = %d\n", dest_len);
#endif

    if (iconv(cd, &src, &src_len, &dest, &dest_len) == -1) {
        printf("failed to iconv errno:%d EILSEQ:%d\n", errno, EILSEQ);
        return result_str;
    }

#if TEST_MODE
    for (int i = 0; i < dest_len; i ++)
        printf("dest[%d] = %d\n", i, saved_dest[i]);
    printf("dest = [%s]\n", saved_dest);
    printf("length of dest = %d\n", dest_len);
#endif

    iconv_close(cd);

    return std::string(saved_dest);
}


int main(void)
{
    std::string message("안녕 블라디미르...");

    std::cout << message << std::endl;
    std::string result = conv_str(message, "EUC-KR", "UTF-8");
    std::cout << "|" << result << "|" << std::endl;

    std::cout << conv_str("하늘이 푸릅니다. 창문을 열면 온방에 하나 가득 가슴에 가득...", "EUC-KR", "UTF-8") << std::endl;

    return 0;
}


