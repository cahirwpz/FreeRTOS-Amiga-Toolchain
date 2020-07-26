CURL = curl -L
RM = rm -f
LHA = lhasa

VASM = vasm1_8h
NDK = NDK_3.9

PREFIX ?= $(PWD)/local
TARGET = m68k-amigaos

all: vasm-install ndk-install

clean: vasm-clean ndk-clean
	$(RM) *~

unpack: vasm-unpack ndk-unpack

.PHONY: all clean download

### VASM

vasm.tar.gz:
	$(CURL) -o $@ "http://server.owl.de/~frank/tags/$(VASM).tar.gz"

vasm-unpack: vasm/.unpack
vasm/.unpack: vasm.tar.gz
	tar xvzf $^
	touch $@

vasm-build: vasm/.build
vasm/.build: vasm/.unpack
	$(MAKE) -C vasm CPU=m68k SYNTAX=mot
	touch $@

vasm-install: vasm/.install
vasm/.install: vasm/.build
	mkdir -p "$(PREFIX)/$(TARGET)/bin"
	mkdir -p "$(PREFIX)/bin"
	cp "vasm/vasmm68k_mot" "$(PREFIX)/$(TARGET)/bin"
	cp "vasm/vobjdump" "$(PREFIX)/bin"
	$(RM) "$(PREFIX)/bin/vasm"
	echo "#!/bin/sh" >> "$(PREFIX)/bin/vasm"
	echo "$(PREFIX)/$(TARGET)/bin/vasmm68k_mot " \
	     "-I$(PREFIX)/$(TARGET)/ndk/include \"\$$@\"" \
		>> "$(PREFIX)/bin/vasm"
	chmod a+x $(PREFIX)/bin/vasm
	touch $@

vasm-clean:
	$(RM) -r vasm

.PHONY: vasm-unpack vasm-build vasm-install vasm-clean

### NDK

$(NDK).lha:
	$(CURL) -o $@ "http://www.haage-partner.de/download/AmigaOS/NDK39.lha"

ndk-unpack: ndk/.unpack
ndk/.unpack: $(NDK).lha
	$(LHA) xf $^
	mv $(NDK) ndk
	$(RM) -r $(NDK).info ndk_3.9
	touch $@

ndk-install: ndk/.install
ndk/.install: ndk/.unpack
	mkdir -p "$(PREFIX)/$(TARGET)"
	rm -rf "$(PREFIX)/$(TARGET)/include"
	cp -r "ndk/Include/include_i" "$(PREFIX)/$(TARGET)/include" 
	find "$(PREFIX)/$(TARGET)/include" -type f | xargs chmod 644

ndk-clean:
	$(RM) -r ndk

.PHONY: ndk-unpack ndk-install ndk-clean
