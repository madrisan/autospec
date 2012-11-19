# Makefile for autospec
# Copyright (C) 2008,2010,2012 by Davide Madrisan <davide.madrisan@gmail.com>

# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY, to the extent permitted by law; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along  with
# this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.

srcdir = ..

include $(srcdir)/Makefile.env

pck_libs := libapse.lib libcfg.lib libmsgmng.lib libnetwork.lib libspec.lib \
            libtest.lib
pck_libs_infiles := $(wildcard *.in)
pck_libs_all := $(pck_libs) README.API

all:

check: $(pck_libs)
	@for f in $(pck_libs); do\
	   echo -n "checking $$f... ";\
	   bash -n $$f \
	      && echo "[PASSED]" || { echo "[FAILED]"; exit 1; };\
	done

pot-files: $(pck_libs)
	@for f in $(pck_libs); do\
	   echo -n "Generating po template '$$f.pot'...";\
	   /usr/bin/xgettext -i -L shell \
	      --copyright-holder="Davide Madrisan" \
	      --msgid-bugs-address="davide.madrisan@gmail.com" \
	      --no-location \
	      --package-name=$(PACKAGE) \
	      --package-version=${VERSION} \
	      $$f -o $(srcdir)/po/$$f.pot 2>/dev/null \
	   && echo "[DONE]" || { echo "[ERROR]"; exit 1; };\
	done

install: $(pck_libs_all)
	@$(INSTALL_DIR) $(DESTDIR)$(libdir)
	for f in $(pck_libs); do\
	   $(INSTALL_DATA) $${f} $(DESTDIR)$(libdir)/$${f};\
	done

uninstall:
	for f in $(pck_libs_all); do\
	   rm -f $(DESTDIR)$(libdir)/$${f};\
	done

clean:
	rm -f $(patsubst %.in,%,$(pck_libs_infiles))
	@for f in $(pck_libs_all); do\
	   rm -f $(srcdir)/po/$$f.pot;\
	done
