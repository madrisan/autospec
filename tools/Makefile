# Makefile for autospec
# Copyright (C) 2008,2012 by Davide Madrisan <davide.madrisan@gmail.com>

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

pck_tools := autoupdate-perl_modules extract-specs
pck_tools_infiles := $(wildcard *.in)

all:

check: $(pck_tools)
	@for f in $(pck_tools); do\
	   echo -n "checking $$f... ";\
	   bash -n $$f \
	      && echo "[PASSED]" || { echo "[FAILED]"; exit 1; };\
	done

install: $(pck_tools)
	@$(INSTALL_DIR) $(DESTDIR)$(tooldir)
	for f in $(pck_tools); do\
	   $(INSTALL_SCRIPT) $${f} $(DESTDIR)$(tooldir)/$${f};\
	done

uninstall:
	for f in $(pck_tools); do\
	   rm -f $(DESTDIR)$(tooldir)/$${f};\
	done

clean:
	rm -f $(patsubst %.in,%,$(pck_tools_infiles))
