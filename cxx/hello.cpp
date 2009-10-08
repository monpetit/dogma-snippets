#include <iostream>
#include <list>
#include <iterator>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

typedef list<int> intseq, *intseqptr;
typedef intseq::const_iterator intiter;
typedef vector<string> strvec, *strvecptr;
typedef strvec::const_iterator strit;

#define EOL		"\n"


int main(void)
{
	intseq x; 

	x.push_back(30043);
	x.push_back(2393);
	x.push_back(3828);
	x.push_back(-30929);

    for (intiter i = x.begin(); i != x.end(); i ++)
        cout << *i << endl;
	cout << "-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" << endl;

	intseqptr y = new intseq();

	y->push_back(30043);
	y->push_back(2393);
	y->push_back(3828);
	y->push_back(-30929);
	y->push_back(30043);
	y->push_back(2393);
	y->push_back(3828);
	y->push_back(-30929);

    for (intiter i = y->begin(); i != y->end(); i ++)
        cout << *i << endl;
	cout << "-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" << endl;

	delete y;

	
	strvecptr s = new strvec();

	s->push_back("gcc(3.0");
	s->push_back("이상)");
	s->push_back("에");
	s->push_back("포함되어");
	s->push_back("있는");
	s->push_back("stl");
	s->push_back("은");
	s->push_back("어떤");
	s->push_back("stl");
	s->push_back("인가요?");
	s->push_back("gcc");
	s->push_back("에서");
	s->push_back("별도");
	s->push_back("제작한건가요?");
	s->push_back("아니면");
	s->push_back("sgi");
	s->push_back("나");
	s->push_back("stl");
	s->push_back("꺼를");
	s->push_back("이용한건가요?");
	s->push_back("그리고");
	s->push_back("sgi");
	s->push_back("stl");
	s->push_back("과");
	s->push_back("stlport");
	s->push_back("와의");
	s->push_back("주된");
	s->push_back("차이점은");
	s->push_back("뭔가요?");
	s->push_back("마지막으로");
	s->push_back("이");
	s->push_back("외에");
	s->push_back("특별한");
	s->push_back("특징을");
	s->push_back("가진");
	s->push_back("유명한");
	s->push_back("stl");
	s->push_back("이");
	s->push_back("있나요?");
	s->push_back("-------------------------------------------------------------------------------------");
	s->push_back("첨언을");
	s->push_back("하자면....");
	s->push_back("여기");
	s->push_back("저기서");
	s->push_back("stlport");
	s->push_back("이야기를");
	s->push_back("많이");
	s->push_back("하길래");
	s->push_back("해당");
	s->push_back("사이트에");
	s->push_back("가서");
	s->push_back("몇가지를");
	s->push_back("능력껏");
	s->push_back("읽어");
	s->push_back("봤는데요.");
	s->push_back("기본은");
	s->push_back("sgi");
	s->push_back("stl");
	s->push_back("을");
	s->push_back("기본");
	s->push_back("베이스로");
	s->push_back("시작해서");
	s->push_back("다양한");
	s->push_back("플랫폼에서");
	s->push_back("컴팔");
	s->push_back("할");
	s->push_back("수");
	s->push_back("있도록");
	s->push_back("했다는");
	s->push_back("내용이");
	s->push_back("있고");
	s->push_back("쓰래드에");
	s->push_back("대한");
	s->push_back("안정성");
	s->push_back("같은");
	s->push_back("몇가지의");
	s->push_back("이야기가");
	s->push_back("나오더군요");
	s->push_back("또한");
	s->push_back("vs");
	s->push_back(".net");
	s->push_back("2003");
	s->push_back("에는");
	s->push_back("기본으로");
	s->push_back("stlport");
	s->push_back("가");
	s->push_back("설치가");
	s->push_back("되고");
	s->push_back("c++");
	s->push_back("builder");
	s->push_back("6");
	s->push_back("에도");
	s->push_back("기본으로");
	s->push_back("stlport");
	s->push_back("가");
	s->push_back("설치되더군요.");
	s->push_back("전");
	s->push_back("기존에");
	s->push_back("stl");
	s->push_back("은");
	s->push_back("sgi");
	s->push_back("stl");
	s->push_back("이");
	s->push_back("유명하다는");
	s->push_back("것");
	s->push_back("정도만");
	s->push_back("알고");
	s->push_back("있었습니다.");
	s->push_back("그리고");
	s->push_back("개발할때는");
	s->push_back("플랫품에");
	s->push_back("기본");
	s->push_back("설치되어");
	s->push_back("있는");
	s->push_back("stl");
	s->push_back("을");
	s->push_back("사용했습니다.");
	s->push_back("그래서");
	s->push_back("표준에");
	s->push_back("벗어나는");
	s->push_back("건");
	s->push_back("사용을");
	s->push_back("하지");
	s->push_back("않았죠");
	s->push_back("예를");
	s->push_back("들면");
	s->push_back("hash");
	s->push_back("가");
	s->push_back("최적인");
	s->push_back("곳에서");
	s->push_back("대신에");
	s->push_back("map");
	s->push_back("을");
	s->push_back("이용해서");
	s->push_back("대처한다든지");
	s->push_back("하는");
	s->push_back("방식을");
	s->push_back("사용했습니다.");
	s->push_back("그런데");
	s->push_back("여기");
	s->push_back("저기");
	s->push_back("글을");
	s->push_back("읽어보면");
	s->push_back("주로");
	s->push_back("stlport");
	s->push_back("를");
	s->push_back("사용하는");
	s->push_back("것");
	s->push_back("같던데");
	s->push_back("왜");
	s->push_back("그걸");
	s->push_back("사용하는지에");
	s->push_back("대한");
	s->push_back("언급을");
	s->push_back("찾을");
	s->push_back("수는");
	s->push_back("없었습니다.");
	s->push_back("결국");
	s->push_back("스스로");
	s->push_back("해결");
	s->push_back("못하고");
	s->push_back("몇가지");
	s->push_back("궁금한게");
	s->push_back("있어서");
	s->push_back("이렇게");
	s->push_back("질문");
	s->push_back("드립니다.");

#if 0
	for (strit i = s->begin(); i != s->end(); i++)
		cout << *i << endl;
	cout << "-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" << endl;
#endif

	copy(s->begin(), s->end(), ostream_iterator<string>(cout, EOL));

	delete s;

    return 0;
}

