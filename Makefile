CC = gcc -s
CXX = g++ -s
PREFIX ?= $(PWD)/local

export CC CXX PREFIX

all: build-vasm build-gnu build-elf2hunk build-fs-uae

build-vasm:
	$(MAKE) -C vasm

build-gnu:
	$(MAKE) -C gnu

build-elf2hunk:
	$(MAKE) -C elf2hunk

build-fs-uae:
	$(MAKE) -C fs-uae

unpack:
	$(MAKE) -C vasm unpack
	$(MAKE) -C gnu unpack
	$(MAKE) -C elf2hunk download
	$(MAKE) -C fs-uae unpack

clean:
	$(MAKE) -C vasm clean
	$(MAKE) -C gnu clean
	$(MAKE) -C elf2hunk clean
	$(MAKE) -C fs-uae clean

.PHONY: all build-vasm build-gnu build-elf2hunk build-fs-uae download clean
