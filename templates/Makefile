# Makefile for autospec
# Copyright (C) 2008,2011,2013,2015 by Davide Madrisan <davide.madrisan@gmail.com>

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

pck_templates := ghc gnome kde3 kde4 kde5 library ocaml-libs perl python standard standard-daemon web

all:

install: $(pck_templates)
	@$(INSTALL_DIR) $(DESTDIR)$(templatedir)
	for f in $(pck_templates); do\
	   $(INSTALL_DATA) $${f} $(DESTDIR)$(templatedir)/$${f};\
	done

uninstall:
	for f in $(pck_templates); do\
	   rm -f $(DESTDIR)$(templatedir)/$${f};\
	done

clean:
