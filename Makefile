TOPDIR = $(CURDIR)
PREFIX ?= $(PWD)/toolchain

MAKEFLAGS := -j$(shell nproc)

all:
	make -C vasm PREFIX=$(PREFIX)
	make -C gnu PREFIX=$(PREFIX)
	make -C elf2hunk PREFIX=$(PREFIX)
	make -C fs-uae PREFIX=$(PREFIX)

download:
	make -C vasm download
	make -C gnu download
	make -C elf2hunk download
	make -C fs-uae download

clean:
	make -C vasm clean
	make -C gnu clean
	make -C elf2hunk clean
	make -C fs-uae clean

.PHONY: all download clean
