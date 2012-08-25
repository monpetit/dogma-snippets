
#include <iostream>
#include <glibmm.h>
#include <locale.h>
#include <boost/tokenizer.hpp>


std::string message = "하늘이 푸릅니다 창문을 열면 "
	"온방에 하나 가득 가슴에 가득 "
	"잔잔한 호수 같은 먼 하늘에 푸름드리 드리운 아침입니다.";

// Glib::convert(const std::string& str, const std::string& to_codeset, const std::string& from_codeset);


int main(int argc, char* argv[])
{
	setlocale (LC_ALL, "") ;

	std::string out_message = Glib::convert(message, "UTF-8", "CP949");
	std::cout << out_message << std::endl;

	std::string text = "가나다";
	std::cout << text << std::endl;
	std::cout << text[1] << std::endl;
	std::cout << text.length() << std::endl;

	Glib::ustring text2 = Glib::locale_to_utf8("가나다 라마바 사아자");
	std::cout << Glib::locale_from_utf8(text2) << std::endl;	
	std::cout << text2.length() << std::endl;
	
	typedef boost::tokenizer< 
		boost::char_delimiters_separator< Glib::ustring::value_type > , 
		Glib::ustring::const_iterator , 
		Glib::ustring > utokenizer ; 
	
	boost::char_delimiters_separator<Glib::ustring::value_type> sep(" ");
	// boost::char_separator<char> sep("-;|");

	utokenizer tokens(text2, sep);
	for (/*utokenizer::iterator*/ auto tok = tokens.begin();
		tok != tokens.end(); ++tok)
		std::cout << "<" << *tok << "> ";
	std::cout << "\n";
	
	return 0;
}

