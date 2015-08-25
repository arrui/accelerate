#!/usr/bin/env bash

DEV = /3.2.6/Platforms/iPhoneOS.platform/Developer
SDK = $(DEV)/SDKs/iPhoneOS4.3.sdk
CC = $(DEV)/usr/bin/arm-apple-darwin10-llvm-gcc-4.2 -std=gnu99
STRIP = $(DEV)/usr/bin/strip -x
LD = $(CC)

SSH = ssh -p 2222 
SCP = scp -P 2222
IP = localhost

MCLEANER_INSTALL ?= NO
MCLEANER_DEBUG ?= NO

MAIN = AccelerateHelper
DIR = /Applications/accelerate.app/
# PLIST = Info.plist
# T_PLIST = $(DIR)/$(PLIST)
# T_MAIN = $(DIR)/$(MAIN)


LDFLAGS = -arch armv6 -isysroot $(SDK) -miphoneos-version-min=3.0 -Wl,-dead_strip -lobjc
LDFLAGS += -lsqlite3
LDFLAGS += -framework CoreFoundation
LDFLAGS += -framework CoreTelephony
LDFLAGS += -framework Foundation
LDFLAGS += -framework UIKit
LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"

CFLAGS = -march=armv6 -mcpu=arm1176jzf-s -x objective-c -pipe -Wno-trigraphs -fpascal-strings -O3 -Wreturn-type -Wunused-variable -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=3.0 -gdwarf-2 -mthumb
CFLAGS += -I"$(SDK)/usr/include"
CFLAGS += -I"."
CFLAGS += -I"$(SDK)/usr/lib/gcc/arm-apple-darwin10/4.0.1/include/"
CFLAGS += -F"$(SDK)/System/Library/Frameworks"
CFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"
CFLAGS += -funroll-loops
#CFLAGS += -DMAC_OS_X_VERSION_MAX_ALLOWED=1050


SOURCES = main.m 

OBJECTS=\
	$(patsubst %.c,%.o,$(filter %.c,$(SOURCES))) \
	$(patsubst %.m,%.o,$(filter %.m,$(SOURCES)))

ifeq ($(MCLEANER_DEBUG),YES)
CFLAGS += -D__DEBUG__
endif

.SUFFIXES: .c .m .h .o
.PHONY: clean

all: $(MAIN)

$(MAIN): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^
	$(STRIP) $@
	export CODESIGN_ALLOCATE=$(DEV)/usr/bin/codesign_allocate
	codesign -f -s "Arrui" $@
	
.m.o: $< $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

.c.o: $< $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	-rm -f $(MAIN)
	-rm -rf data.tar.gz control.tar.gz dist
	find . -name "*.o" -exec rm {} \; -print

i:install

install: all
	$(SSH) root@$(IP) 'rm -f $(DIR)/$(MAIN)'
	$(SCP) $(MAIN) root@$(IP):$(DIR)/$(MAIN)
	$(SSH) root@$(IP) chmod 777 $(DIR)/$(MAIN)

p:pkg

pkg:all
	./pkg.sh

rm:
	$(SSH) root@$(IP) 'rm -f $(DIR)/$(MAIN)'

g:gdb
	
gdb: install
	$(SSH) root@$(IP) gdb $(DIR)/$(MAIN)
	
k:kill

kill:
	-$(SSH) root@$(IP) 'killall $(MAIN)'
	-$(SSH) root@$(IP) 'ps aux|grep $(MAIN)'
	
l:login

login:
	$(SSH) root@$(IP)