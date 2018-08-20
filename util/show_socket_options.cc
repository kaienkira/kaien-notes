#include <unistd.h>
#include <sys/socket.h>
#include <cstdio>

static void showTcpOptions()
{
    int fd = ::socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        return;
    }

    do {
        {
            int opt = 0;
            socklen_t opt_len = sizeof(opt);
            if (::getsockopt(fd, SOL_SOCKET, SO_SNDBUF, &opt, &opt_len) != 0) {
                break;
            }
            ::printf("socket send_buffer_size(SO_SNDBUF): %d\n", opt);
        }

    } while (false);

    ::close(fd);
}

int main(int argc, char *argv[])
{
    showTcpOptions();

    return 0;
}
