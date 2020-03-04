CURL = curl -L
RM = rm -f
INSTALL = install

CFLAGS ?= -O2 -Wall

PREFIX ?= $(PWD)/local

all: elf2hunk-install

download: elf2hunk.c

elf2hunk.c:
	$(CURL) -o $@ "https://raw.githubusercontent.com/aros-development-team/AROS/master/tools/elf2hunk/elf2hunk.c"

elf2hunk-patch: .pc/applied-patches
.pc/applied-patches: elf2hunk.c
	quilt push -a

elf2hunk-unpatch: .pc/applied-patches
	quilt pop -a

elf2hunk-build: elf2hunk-patch elf2hunk

elf2hunk-install: elf2hunk-build
	$(INSTALL) -s -m 755 elf2hunk $(PREFIX)/bin

clean: elf2hunk-unpatch
	$(RM) elf2hunk *~
	$(RM) -r elf2hunk.dSYM

.PHONY: elf2hunk-build elf2hunk-patch elf2hunk-unpatch elf2hunk-install
.PHONY: download all clean
