/* Copyright (c) 2023, Michael Santos <michael.santos@gmail.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#include <err.h>
#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "restrict_process.h"

#define NOSOCKEXEC_VERSION "0.1.0"

static void usage();

static const struct option long_options[] = {{"help", no_argument, NULL, 'h'},
                                             {NULL, 0, NULL, 0}};

int main(int argc, char *argv[]) {
  int ch;

  while ((ch = getopt_long(argc, argv, "+h", long_options, NULL)) != -1) {
    switch (ch) {
    case 'h':
    default:
      usage();
    }
  }

  argc -= optind;
  argv += optind;

  if (argc < 1) {
    usage();
  }

  if (restrict_process() < 0)
    err(111, "nosockexec");

  (void)execvp(argv[0], argv);

  err(127, "%s", argv[0]);
}

static void usage() {
  errx(EXIT_FAILURE,
       "[OPTION] <COMMAND> <...>\n"
       "version: %s (%s)\n"
       "-h, --help                usage summary",
       NOSOCKEXEC_VERSION, RESTRICT_PROCESS);
}
