import std.stdio;
import std.thread;

class PetitThread : Thread
{
	public int run () {
		for (int i = 0; i < 500; i++) {
			writef("Hello Monpetit. %d\n", i);
			yield();
		}
		writef("PETIT THREAD END!!!\n");
		return 0;
	}
}

class HamaThread : PetitThread
{
	public int run () {
		for (int i = 0; i < 300; i++) {
			writef("안녕 세상아. %d\n", i);
			yield();
		}
		writef("HAHA THREAD END!!!\n");
		return 0;
	}
}

class DogmaThread : HamaThread
{
	public int run () {
		for (int i = 0; i < 250; i++) {
			writef("안녕 도그마. %d\n", i);
			yield();
		}
		writef("DOGMA THREAD END!!!\n");
		return 0;
	}
}


int main (char[][] args)
{
	Thread ths[3];
	ths[0] = new PetitThread();
	ths[1] = new HamaThread();
	ths[2] = new DogmaThread();

	foreach (th; ths)	 th.start();

    writef("Testing the D Code\n");
    writef("File:                %s\n",__FILE__);
    writef("Line:                %s\n",__LINE__);
    writef("Date:                %s\n",__DATE__);
    writef("Time:                %s\n",__TIME__);
    writef("TimeStamp:   %s\n",__TIMESTAMP__);

	foreach (th; ths)	 th.wait();

    return 0;
}
