.PHONY: all clean test

PROG=   nonetexec
SRCS=   nonetexec.c \
				restrict_process_seccomp.c

UNAME_SYS := $(shell uname -s)
ifeq ($(UNAME_SYS), Linux)
    CFLAGS ?= -D_FORTIFY_SOURCE=2 -O2 -fstack-protector-strong \
              -Wformat -Werror=format-security \
              -fno-strict-aliasing
    LDFLAGS += -Wl,-z,relro,-z,now
	  RESTRICT_PROCESS ?= seccomp
else ifeq ($(UNAME_SYS), OpenBSD)
    CFLAGS ?= -D_FORTIFY_SOURCE=2 -O2 -fstack-protector-strong \
              -Wformat -Werror=format-security \
              -fno-strict-aliasing
    LDFLAGS += -Wno-missing-braces -Wl,-z,relro,-z,now
    RESTRICT_PROCESS ?= pledge
else ifeq ($(UNAME_SYS), FreeBSD)
    CFLAGS ?= -D_FORTIFY_SOURCE=2 -O2 -fstack-protector-strong \
              -Wformat -Werror=format-security \
              -fno-strict-aliasing
    LDFLAGS += -Wno-missing-braces -Wl,-z,relro,-z,now
    NONETEXEC ?= capsicum
else ifeq ($(UNAME_SYS), Darwin)
    CFLAGS ?= -D_FORTIFY_SOURCE=2 -O2 -fstack-protector-strong \
              -Wformat -Werror=format-security \
              -fno-strict-aliasing
    LDFLAGS += -Wno-missing-braces
endif

RM ?= rm

NONETEXEC_CFLAGS ?= -g -Wall -fwrapv -pedantic -pie -fPIE
NONETEXEC_CFLAGS ?= -g -Wall -Wextra -fwrapv -pedantic -pie -fPIE

CFLAGS += $(NONETEXEC_CFLAGS) \
          -DNONETEXEC=\"$(NONETEXEC)\" \
          -DNONETEXEC_$(NONETEXEC)

LDFLAGS += $(NONETEXEC_LDFLAGS)

all: $(PROG)

$(PROG):
	$(CC) $(CFLAGS) \
		-DRESTRICT_PROCESS=\"$(RESTRICT_PROCESS)\" -DRESTRICT_PROCESS_$(RESTRICT_PROCESS) \
		-o $(PROG) $(SRCS) $(LDFLAGS)

clean:
	-@$(RM) $(PROG)

test: $(PROG)
	@PATH=.:$(PATH) bats test
