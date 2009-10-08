// This code is derived from the
// RSA Data Security, Inc. MD5 Message-Digest Algorithm.

import std.md5;

private import std.stdio;
private import std.string;
private import std.c.stdio;
private import std.c.string;

int main(char[][] args)
{
    foreach (char[] arg; args)
	 MDFile(arg);
    return 0;
}

/* Digests a file and prints the result. */
void MDFile(char[] filename)
{
    FILE* file;
    MD5_CTX context;
    int len;
    ubyte[4 * 1024] buffer;
    ubyte digest[16];

    if ((file = fopen(std.string.toStringz(filename), "rb")) == null)
	writefln("%s can't be opened", filename);
    else
    {
	context.start();
	while ((len = fread(&buffer, 1u, buffer.sizeof, file)) != 0)
	    context.update(buffer[0 .. len]);
	context.finish(digest);
	fclose(file);

	writefln("MD5 (%s) = %s", filename, digestToString(digest));
    }
}
