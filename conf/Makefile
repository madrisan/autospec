# Makefile for autospec
# Copyright (C) 2012 by Davide Madrisan <davide.madrisan@gmail.com>

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

pck_confs_infiles := $(wildcard *.conf.in)
pck_confs := \
   $(wildcard *.conf) $(patsubst %.conf.in,%.conf,$(wildcard *.conf.in))

pck_color_themes := $(wildcard color-theme.*)

all:

check: $(pck_confs) $(pck_color_themes)
	@for f in $(pck_confs) $(pck_color_themes); do\
	   echo -n "checking $$f... ";\
	   bash -n $$f \
	      && echo "[PASSED]" || { echo "[FAILED]"; exit 1; };\
	done

install: $(pck_confs) $(pck_color_themes)
	@$(INSTALL_DIR) $(DESTDIR)$(confdir)
	for f in $(pck_confs) $(pck_color_themes); do\
	   if [ $${f} = "autospec.conf" ]; then\
	      $(INSTALL_DATA) $${f} $(DESTDIR)$(sysconfdir)/$${f};\
	   else\
	      $(INSTALL_DATA) $${f} $(DESTDIR)$(confdir)/$${f};\
	   fi;\
	done

uninstall:
	for f in $(pck_confs); do\
	   rm -f $(DESTDIR)$(confdir)/$${f};\
	done

clean:
	rm -f $(patsubst %.in,%,$(pck_confs_infiles))
