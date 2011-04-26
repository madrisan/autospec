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

LANG=it

pck_manpages := autospec.1

all:

install: $(pck_manpages)
	$(INSTALL_DIR) $(DESTDIR)$(mandir)/$(LANG)/man1;\
	for f in $(pck_manpages); do\
	   $(INSTALL_DATA) $${f} $(DESTDIR)$(mandir)/$(LANG)/man1/$${f};\
	done

uninstall:
	@for f in $(pck_manpages); do\
	   echo "rm -f $(DESTDIR)$(mandir)/$(LANG)/man1/$${f}";\
	   rm -f $(DESTDIR)$(mandir)/$(LANG)/man1/$${f};\
	done

clean:
	rm -f $(pck_manpages)
