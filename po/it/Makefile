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

pck_catalogs_tmpl := autospec_fe.pot \
   config-getvar.pot \
   libapse.pot \
   libcfg.pot \
   libmsgmng.pot \
   libnetwork.pot \
   libspec.pot \
   libtest.pot \
   pck-extract.pot \
   pck-update.pot \
   spec-create.pot \
   test00_specsyntax.pot \
   test01_pkgquality.pot \
   test02_pkgsecurity.pot

pck_catalog_tmpl := $(PACKAGE).pot
pck_catalog := $(PACKAGE).po

LANG=it

.SUFFIXES:
.SUFFIXES: .po .mo .in
.po.mo:; @echo "Generating binary message catalog '$@'..."; \
       msgfmt $< -o $@

all: locales

pck_manpages := 

merge-pot-files: $(patsubst %,$(srcdir)/po/%,$(pck_catalogs_tmpl))
	@echo "Creating global pot file...";\
	/bin/cat $(patsubst %,$(srcdir)/po/%,$(pck_catalogs_tmpl)) \
	   > $(srcdir)/po/$(PACKAGE)-all.pot;\
	/usr/bin/msguniq --use-first --no-location --no-wrap \
	   $(srcdir)/po/$(PACKAGE)-all.pot \
	   -o $(srcdir)/po/$(pck_catalog_tmpl) && \
	   echo "... $(PACKAGE)-all.pot [DONE]" || \
	   { echo ".. $(PACKAGE)-all.pot [FAILED]"; exit 1; }

locales: merge-pot-files
	@echo "Generating global locale...";\
	/usr/bin/msgmerge --update --no-fuzzy-matching --indent \
	   $(pck_catalog) \
	   $(srcdir)/po/$(pck_catalog_tmpl) && \
	   echo "... $(pck_catalog) [DONE]" || \
	   { echo "... $(pck_catalog) [FAILED]"; exit 1; }
	@echo -n "Checking $(pck_catalog) for untranslated strings... ";\
	/bin/grep -q 'msgstr[ \t]*\"\"' $(pck_catalog) && \
	   { echo "[UNTRASLATED STRING]"; exit 1; } || \
           echo "[NONE]"

install: $(pck_catalog:.po=.mo)
	@destdir="$(DESTDIR)$(localedir)/$(LANG)/LC_MESSAGES";\
	$(INSTALL_DIR) $$destdir;\
	$(INSTALL_DATA) $(PACKAGE).mo $$destdir/$(PACKAGE).mo

uninstall:
	rm -f $(DESTDIR)$(localedir)/$(LANG)/LC_MESSAGES/$(PACKAGE).mo

clean:
	rm -f $(PACKAGE).mo
	rm -f $(srcdir)/po/*.pot
	rm -f *.po~
