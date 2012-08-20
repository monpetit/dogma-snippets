#include <iostream>
#include <string>
#include <cstring>
#include <glibmm.h>
#include <giomm.h>

using namespace Glib;

typedef std::vector<ustring> ustrvec_t;

template <typename T>
inline void prt(const T object)
{
    std::cout << object << std::endl;
}

int main()
{
    std::locale::global(std::locale(""));  // Glib::ustring을 char*로 변환 없이 출력할 수 있도록...

    const std::string  hello = "자연지리학自然地理學植_계량경제학計量經濟學";

    prt(hello.size());
    prt(hello);

    ustring uhello(hello);
    prt(uhello.size());
    prt(uhello);

    MatchInfo minfo;
    auto regex = Regex::create(".+");
    if (regex->match(uhello, /*uhello.size(),*/ 0, REGEX_MATCH_NEWLINE_ANY))
        prt("match!");

    // Watch out!
    // match_all()의 두번째 인자로 ustring의 길이가 아닌 char* 형으로 변환한 문자열의
    // 길이가 들어간다는 기괴한 사실...
    if (regex->match_all(uhello, /*strlen(uhello.data()),*/ 0, minfo, REGEX_MATCH_NOTEMPTY)) {
        ustrvec_t results = minfo.fetch_all();
        prt(results.size());
        for (size_t i = 0; i < results.size(); i++)
            std::cout << "|" << results[i] << "|" << std::endl;
    }

    for (auto ch = uhello.begin(); ch != uhello.end(); ch++)
        std::wcout << *ch << std::endl;

    return 0;
}

