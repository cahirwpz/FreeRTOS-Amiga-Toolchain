CURL = curl -L
RM = rm -f

# MAKEFLAGS = -j$(shell nproc)

CFLAGS ?= -O2 -Wall
PREFIX ?= $(PWD)/local
GETTEXT_PATH = $(wildcard /usr/local/Cellar/gettext/*)

VER = 3.0.0

all: install

download: fs-uae-$(VER).tar.gz

fs-uae-$(VER).tar.gz:
	$(CURL) -o $@ "https://fs-uae.net/stable/$(VER)/fs-uae-$(VER).tar.gz"

unpack: fs-uae/.unpack
fs-uae/.unpack: fs-uae-$(VER).tar.gz
	tar xvzf $^
	mv fs-uae-$(VER) fs-uae
	touch $@

patch: .pc/applied-patches
.pc/applied-patches: fs-uae/.unpack
	quilt push -a

configure: fs-uae/.configure
fs-uae/.configure: .pc/applied-patches
	cd fs-uae && PATH=$(GETTEXT_PATH)/bin:$$PATH ./configure \
		--prefix=$(PREFIX) \
		--enable-gdbstub \
		--without-libmpeg2 \
		--disable-action-replay \
		--disable-ahi \
		--disable-arcadia \
		--disable-builtin-slirp \
		--disable-gfxboard \
		--disable-jit \
		--disable-lua \
		--disable-netplay \
		--disable-pearpc-cpu \
		--disable-ppc \
		--disable-prowizard \
		--disable-qemu-cpu \
		--disable-qemu-slirp \
		--disable-uaenet \
		--disable-uaescsi \
		--disable-uaeserial \
		--disable-dms \
		--disable-zip
	touch $@

build: fs-uae/.build
fs-uae/.build: fs-uae/.configure
	cd fs-uae && $(MAKE)
	touch $@

install: fs-uae/.install
fs-uae/.install: fs-uae/.build
	cd fs-uae && $(MAKE) install-strip
	touch $@

force-build:
	$(RM) fs-uae/.build fs-uae/.install
	$(MAKE) install

clean:
	-quilt pop -a
	$(RM) -r fs-uae

.PHONY: unpack patch configure build install force-build download
