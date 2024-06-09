# SYNOPSIS

nonetexec *cmd* *...*

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

## curl(1): process does not access network

```
$ nonetexec curl file:///etc/hosts
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
$ nonetexec curl http://1.1.1.1
curl: (7) Couldn't connect to server
```

# Build

```
make

#### static executable using musl
./musl-make
```

# OPTIONS

None
