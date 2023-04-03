# SYNOPSIS

nonetexect *cmd* *...*

# DESCRIPTION

nonetexec: prevent an exec(3)'ed command from opening sockets

`nonetexec` removes the capability of an executed command to open network
sockets. The process can open filesystem objects or use sockets inherited
from the parent.

The process may still access the network by using:

* systemd socket activation

* a inetd or [UCSPI](https://jdebp.uk/FGA/UCSPI.html) service with
  standard input and output attached to a socket

* file descriptor passing over a socketpair(2) inherited from the parent

# EXAMPLES

The examples demonstrate running a restricted process under
[tcpexec](https://github.com/msantos/tcpexec).

## curl(1): process does not access network

```
# shell 1
$ tcpexec 0.0.0.0:9091 nonetexec curl file:///etc/hosts; echo $?
0

# shell 2
$ echo | nc localhost 9091
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```

## curl(1): process attempts to access network

```
# shell 1
$ tcpexec 0.0.0.0:9091 nonetexec curl http://1.1.1.1; echo $?
curl: (7) Couldn't connect to server
7

# shell 2
$ echo | nc localhost 9091
```

# Build

```
make

#### static executable using musl
./musl-make
```

# OPTIONS

None
