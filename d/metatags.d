version (Tango)
{
	import tango.io.Stdout;
	import tango.text.convert.Integer : parseInt = toString;
}
else
{
	import std.stdio;
	import std.string : parseInt = toString;
}


int main (char[][] args)
{
    writef("Testing the D Code\n");
    writef("File:                %s\n",__FILE__);
    writef("Line:                %s\n",__LINE__);
    writef("Date:                %s\n",__DATE__);
    writef("Time:                %s\n",__TIME__);
    writef("TimeStamp:   %s\n",__TIMESTAMP__);

    return 0;
}
