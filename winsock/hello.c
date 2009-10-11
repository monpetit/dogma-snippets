#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 1024

typedef char* charptr;


void err_quit(charptr msg)
{
    LPVOID buffer;

    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
        NULL,
        WSAGetLastError(),
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR)&buffer,
        0,
        NULL);
    MessageBox(NULL, (LPCTSTR)buffer, msg, MB_ICONERROR);
    LocalFree(buffer);

    exit(-1);
}


void err_display(charptr msg)
{
    LPVOID buffer;

    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
        NULL,
        WSAGetLastError(),
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR)&buffer,
        0,
        NULL);
    printf("[%s] %s", msg, (LPCTSTR)buffer);
    LocalFree(buffer);
}


int main(int argc, char *argv[])
{
    int retval;
    WSADATA wsa;
    SOCKET sock, client_sock;
    SOCKADDR_IN serveraddr, clientaddr;
    int addrlen;
    char buffer[BUFSIZE+1];

    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
        return -1;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == INVALID_SOCKET)
        err_quit("socket()");

    ZeroMemory(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(9000);
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    retval = bind(sock, (SOCKADDR*)&serveraddr, sizeof(serveraddr));
    if (retval == SOCKET_ERROR)
        err_quit("bind()");

    retval = listen(sock, SOMAXCONN);
    if (retval == SOCKET_ERROR)
        err_quit("listen()");

    while (1) {
        addrlen = sizeof(clientaddr);
        client_sock = accept(sock, (SOCKADDR*)&clientaddr, &addrlen);
        if (client_sock == INVALID_SOCKET) {
            err_display("accept()");
            continue;
        }

        printf("\n[TCP 서버] 클라이언트 접속: IP 주소 = %s, 포트번호 = %d\n",
            inet_ntoa(clientaddr.sin_addr),
            ntohs(clientaddr.sin_port));

        while (1) {
            retval = recv(client_sock, buffer, BUFSIZE, 0);
            if (retval == SOCKET_ERROR) {
                err_display("recv()");
                continue;
            }
            else if (retval == 0) {
                break;
            }
            else {
                buffer[retval] = 0x00;
                printf("%s", buffer);
            }
        }

        closesocket(client_sock);
        printf("\n[TCP 서버] 클라이언트 종료: IP 주소 = %s, 포트번호 = %d\n",
            inet_ntoa(clientaddr.sin_addr),
            ntohs(clientaddr.sin_port));
    }

    closesocket(sock);
    WSACleanup();

    return 0;
}

