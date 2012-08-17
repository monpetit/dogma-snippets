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

     const std::string std_color = "FF00231A";
     ustring color(std_color);

     prt(std_color);
     prt(std_color.size());
     prt(color);
     prt(color.size());


     MatchInfo minfo;
     // auto regex = Regex::create("[0-9a-fFA-F]+");
     auto regex = Regex::create("([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})");
     if (regex->match(color, 0, REGEX_MATCH_NOTEMPTY))
	  prt("match!");

     if (regex->match(color, 0, minfo, REGEX_MATCH_NOTEMPTY)) {
	  ustrvec_t results = minfo.fetch_all();
	  prt(results.size());
	  for (size_t i = 0; i < results.size(); i++)
	       std::cout << "|" << results[i] << "|" << std::endl;
     }

     return 0;
}
