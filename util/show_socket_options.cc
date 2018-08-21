#include <unistd.h>
#include <sys/socket.h>
#include <cstdio>
#include <limits>

static int getSocketOptSndBuf(int fd)
{
    int opt = 0;
    socklen_t opt_len = sizeof(opt);

    if (::getsockopt(fd, SOL_SOCKET, SO_SNDBUF, &opt, &opt_len) != 0) {
        return -1;
    }

    return opt;
}

static void setSocketOptSndBuf(int fd, int opt)
{
    ::setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &opt, sizeof(opt));
}

static void printSocketOptSndBuf(int fd, const char *socket_type)
{
    int default_size = getSocketOptSndBuf(fd);
    setSocketOptSndBuf(fd, 0);
    int min_size = getSocketOptSndBuf(fd);
    setSocketOptSndBuf(fd, std::numeric_limits<int>::max());
    int max_size = getSocketOptSndBuf(fd);

    ::printf("%s send_buffer_size(SO_SNDBUF): "
             "min: %d default: %d max: %d\n",
             socket_type, min_size, default_size, max_size);
}

static void showTcpOptions()
{
    int fd = ::socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        return;
    }

    printSocketOptSndBuf(fd, "tcp_socket");

    ::close(fd);
}

static void showUdpOptions()
{
    int fd = ::socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        return;
    }

    printSocketOptSndBuf(fd, "udp_socket");

    ::close(fd);
}

int main(int argc, char *argv[])
{
    showTcpOptions();
    showUdpOptions();

    return 0;
}
