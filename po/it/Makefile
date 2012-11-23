# Makefile for autospec
# Copyright (C) 2008 by Davide Madrisan <davide.madrisan@gmail.com>

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

srcdir = ../..

include $(srcdir)/Makefile.env

pck_catalogs := $(wildcard *.po)

LANG=it

.SUFFIXES:
.SUFFIXES: .po .mo .in
.po.mo:; @echo "Generating binary message catalog '$@'..."; \
       msgfmt $< -o $@

all: locales

locales: $(pck_catalogs:.po=.mo)

pck_manpages := 

pot-merge: $(patsubst %.po,%.pot,$(wildcard $(srcdir)/po/*.po))
	@for f in $(pck_catalogs:.po=); do\
	   echo "Merging '$$f.po' with '$$f.pot'...";\
	   /usr/bin/msgmerge --update --no-wrap \
	      $$f.po $(srcdir)/po/$$f.pot;\
	done

locales-concatenate: pot-merge
	@echo "Concatenating locales...";\
	/usr/bin/msgcat $(pck_catalogs:.po=) -o $(PACKAGE)-all.po;\
	echo "... $(PACKAGE)-all.po [DONE]"

install: locales
	@destdir="$(DESTDIR)$(localedir)/$(LANG)/LC_MESSAGES";\
	$(INSTALL_DIR) $$destdir;\
	for f in $(pck_catalogs:.po=); do\
	   $(INSTALL_DATA) $${f}.mo $$destdir/$${f}.mo;\
	done

uninstall:
	@for f in $(pck_catalogs:.po=); do\
	   echo "rm -f $(DESTDIR)$(localedir)/$(LANG)/LC_MESSAGES/$${f}.mo";\
	   rm -f $(DESTDIR)$(localedir)/$(LANG)/LC_MESSAGES/$${f}.mo;\
	done

clean:
	rm -f $(pck_catalogs:.po=.mo)
	rm -f $(srcdir)/po/$(PACKAGE)-all.po
	rm -f *.po~
