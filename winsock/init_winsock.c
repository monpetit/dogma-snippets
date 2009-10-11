#include <winsock2.h>


int main(int argc, char *argv[])
{
    WSADATA wsa;

    if (WSAStartup(MAKEWORD(2, 2), &wsa) != S_OK)
        return -1;

    MessageBox(NULL, "winsock 초기화 성공", "성공", MB_OK);

    WSACleanup();
    
    return 0;
}

