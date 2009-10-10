/*
 * compile: gcc -O2 -mwindows -o system system.c
 */

#include <windows.h>

// int APIENTRY WinMain(HINSTANCE h, HINSTANCE g, LPSTR s, int i)
int main(int argc, char* argv[])
{
	return (int) WinExec("notepad", 1);
}
