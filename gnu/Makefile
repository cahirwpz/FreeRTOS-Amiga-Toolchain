CURL = curl -L
RM = rm -f

ifeq ($(shell uname),FreeBSD)
MAKEFLAGS = -j$(shell sysctl -n hw.ncpu)
else
MAKEFLAGS = -j$(shell nproc)
endif

ISL = isl-0.21
MPFR = mpfr-4.0.2
GMP = gmp-6.1.2
MPC = mpc-1.1.0
BINUTILS = binutils-2.32
GCC = gcc-8.3.0
GDB = gdb-8.3

ROOTDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
HOSTDIR := $(ROOTDIR)/host
PREFIX ?= $(ROOTDIR)/local
TARGET = m68k-elf

all: gcc-install gdb-install

clean: gmp-clean mpfr-clean mpc-clean isl-clean binutils-clean gcc-clean gdb-clean
	$(RM) -r host
	$(RM) *~

unpack: gmp-unpack mpfr-unpack mpc-unpack isl-unpack binutils-unpack gcc-unpack gdb-unpack

.PHONY: all clean download

### The GNU Multiple Precision Arithmetic Library

$(GMP).tar.xz:
	$(CURL) -o $@ "https://gmplib.org/download/gmp/$(GMP).tar.xz"

gmp-unpack: gmp/.unpack
gmp/.unpack: $(GMP).tar.xz
	tar xJf $^
	mv $(GMP) gmp
	touch $@

gmp-configure: gmp/.configure
gmp/.configure: gmp/.unpack
	cd gmp && ./configure \
		--disable-shared --prefix=$(HOSTDIR)
	touch $@

gmp-build: gmp/.build
gmp/.build: gmp/.configure
	cd gmp && $(MAKE)
	touch $@

gmp-install: gmp/.install
gmp/.install: gmp/.build
	cd gmp && $(MAKE) install-strip
	touch $@

gmp-clean:
	$(RM) -r gmp

.PHONY: gmp-unpack gmp-configure gmp-build gmp-install gmp-clean

### Library for multiple-precision floating-point computations

$(MPFR).tar.xz:
	$(CURL) -o $@ "https://ftp.gnu.org/gnu/mpfr/$(MPFR).tar.xz"

mpfr-unpack: mpfr/.unpack
mpfr/.unpack: $(MPFR).tar.xz
	tar xJf $^
	mv $(MPFR) mpfr
	touch $@

mpfr-configure: mpfr/.configure
mpfr/.configure: mpfr/.unpack gmp/.install
	cd mpfr && ./configure \
		--disable-shared --prefix=$(HOSTDIR) --with-gmp=$(HOSTDIR)
	touch $@

mpfr-build: mpfr/.build
mpfr/.build: mpfr/.configure
	cd mpfr && $(MAKE)
	touch $@

mpfr-install: mpfr/.install
mpfr/.install: mpfr/.build
	cd mpfr && $(MAKE) install-strip
	touch $@

mpfr-clean:
	$(RM) -r mpfr

.PHONY: mpfr-unpack mpfr-configure mpfr-build mpfr-install mpfr-clean

### Library for the arithmetic of complex numbers

$(MPC).tar.gz:
	$(CURL) -o $@ "https://ftp.gnu.org/gnu/mpc/$(MPC).tar.gz"

mpc-unpack: mpc/.unpack
mpc/.unpack: $(MPC).tar.gz
	tar xzf $^
	mv $(MPC) mpc
	touch $@

mpc-configure: mpc/.configure
mpc/.configure: mpc/.unpack gmp/.install mpfr/.install
	cd mpc && ./configure \
		--disable-shared \
		--prefix=$(HOSTDIR) \
		--with-gmp=$(HOSTDIR) \
		--with-mpfr=$(HOSTDIR)
	touch $@

mpc-build: mpc/.build
mpc/.build: mpc/.configure
	cd mpc && $(MAKE)
	touch $@

mpc-install: mpc/.install
mpc/.install: mpc/.build
	cd mpc && $(MAKE) install-strip
	touch $@

mpc-clean:
	$(RM) -r mpc

.PHONY: mpc-unpack mpc-configure mpc-build mpc-install mpc-clean

### Integer Set Library

$(ISL).tar.xz:
	$(CURL) -o $@ "http://isl.gforge.inria.fr/$(ISL).tar.xz"

isl-unpack: isl/.unpack
isl/.unpack: $(ISL).tar.xz
	tar xJf $^
	mv $(ISL) isl
	touch $@

isl-configure: isl/.configure
isl/.configure: isl/.unpack gmp/.install
	cd isl && ./configure \
		--disable-shared \
		--prefix=$(HOSTDIR) \
		--with-gmp-prefix=$(HOSTDIR)
	touch $@

isl-build: isl/.build
isl/.build: isl/.configure
	cd isl && $(MAKE)
	touch $@

isl-install: isl/.install
isl/.install: isl/.build
	cd isl && $(MAKE) install-strip
	touch $@

isl-clean:
	$(RM) -r isl

.PHONY: isl-unpack isl-configure isl-build isl-install isl-clean

### List of all requisite libraries

LIBRARIES = gmp/.install mpfr/.install mpc/.install isl/.install

### GNU Binutils

$(BINUTILS).tar.xz:
	$(CURL) -o $@ "https://ftp.gnu.org/gnu/binutils/$(BINUTILS).tar.xz"

binutils-unpack: binutils/.unpack
binutils/.unpack: $(BINUTILS).tar.xz
	tar xJf $^
	mv $(BINUTILS) binutils
	touch $@

binutils-configure: binutils/.configure
binutils/.configure: binutils/.unpack $(LIBRARIES)
	cd binutils && ./configure \
		--target=$(TARGET) \
		--disable-nls \
		--disable-plugins \
                --disable-werror \
		--prefix=$(PREFIX) \
		--with-gmp=$(HOSTDIR) \
		--with-mpfr=$(HOSTDIR) \
		--with-mpc=$(HOSTDIR) \
		--with-isl=$(HOSTDIR) \
                --with-python=$(shell which python3)
	touch $@

binutils-build: binutils/.build
binutils/.build: binutils/.configure
	cd binutils && $(MAKE)
	touch $@

binutils-install: binutils/.install
binutils/.install: binutils/.build
	cd binutils && $(MAKE) install-strip
	touch $@

binutils-clean:
	$(RM) -r binutils

.PHONY: binutils-unpack binutils-configure binutils-build binutils-install binutils-clean

### GNU Compiler Collection

$(GCC).tar.xz:
	$(CURL) -o $@ "https://ftp.gnu.org/gnu/gcc/$(GCC)/$(GCC).tar.xz"

gcc-unpack: gcc/.unpack
gcc/.unpack: $(GCC).tar.xz
	tar xJf $^
	mv $(GCC) gcc
	touch $@

gcc-configure: gcc/.configure
gcc/.configure: gcc/.unpack binutils/.install $(LIBRARIES)
	cd gcc && PATH=$(PREFIX)/bin:$$PATH ./configure \
		--target=$(TARGET) \
		--prefix=$(PREFIX) \
		--datarootdir=$(PREFIX)/$(TARGET)/share \
		--with-gmp=$(HOSTDIR) \
		--with-mpfr=$(HOSTDIR) \
		--with-mpc=$(HOSTDIR) \
		--with-isl=$(HOSTDIR) \
		--enable-languages=c \
		--enable-lto \
		--without-headers \
		--disable-multilib \
		--disable-nls \
		--disable-shared \
            	--disable-werror
	touch $@

gcc-build: gcc/.build
gcc/.build: gcc/.configure
	cd gcc && $(MAKE) all-gcc
	touch $@

gcc-install: gcc/.install
gcc/.install: gcc/.build
	cd gcc && $(MAKE) install-strip-gcc
	touch $@

gcc-clean:
	$(RM) -r gcc

.PHONY: gcc-unpack gcc-configure gcc-build gcc-install gcc-clean

### GNU Debugger

$(GDB).tar.xz:
	$(CURL) -o $@ "https://ftp.gnu.org/gnu/gdb/$(GDB).tar.xz"

gdb-unpack: gdb/.unpack
gdb/.unpack: $(GDB).tar.xz
	tar xJf $^
	mv $(GDB) gdb
	touch $@

gdb-configure: gdb/.configure
gdb/.configure: gdb/.unpack gcc/.install $(LIBRARIES)
	cd gdb && PATH=$(PREFIX)/bin:$$PATH ./configure \
		--target=$(TARGET)\
		--with-isl=$(HOSTDIR) \
		--prefix=$(PREFIX) \
	        --datarootdir=$(PREFIX)/$(TARGET)/share \
            	--with-sysroot=$(PREFIX)/$(TARGET) \
            	--disable-binutils \
            	--disable-gas \
            	--disable-ld \
            	--disable-nls \
		--disable-sim \
		--disable-werror \
		--disable-source-highlight \
		--with-tui \
		--with-python=$(shell which python3)
	touch $@

gdb-build: gdb/.build
gdb/.build: gdb/.configure
	cd gdb && $(MAKE)
	touch $@

gdb-install: gdb/.install
gdb/.install: gdb/.build
	cd gdb && $(MAKE) install-strip-gdb
	touch $@

gdb-clean:
	$(RM) -r gdb

.PHONY: gdb-unpack gdb-configure gdb-build gdb-install gdb-clean
