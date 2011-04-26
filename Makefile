# Makefile for autospec
# Copyright (C) 2004-2008 by Davide Madrisan <davide.madrisan@gmail.com>

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

include VERSION
include Makefile.env

PACKAGE = autospec
FRONTEND = $(PACKAGE)
PACKAGE_LIB = libspec.lib

LOCALES = it

srcdir = .

distdir = $(PACKAGE)-$(VERSION)
dist_archive = $(distdir).tar.bz2

DESTDIR =

pck_conf = $(PACKAGE).conf
pck_libs := $(sort $(patsubst %.in,%,$(wildcard lib/*)))
pck_manpages := $(patsubst %.in,%,$(wildcard man/*.in man/*/*.in))
pck_plugins := $(sort $(patsubst %.in,%,$(wildcard plugins/*)))
pck_templates := $(sort $(patsubst %.in,%,$(wildcard templates/*)))
pck_tests := $(sort $(patsubst %.in,%,$(wildcard tests/*)))
pck_tools := $(sort $(patsubst %.in,%,$(wildcard tools/*)))

pck_infiles := $(wildcard *.in lib/*.in man/*.in man/*/*.in plugins/*.in templates/.in tests/* tools/*.in)

.SUFFIXES:
.SUFFIXES: .in

.in:; @echo "Generating $@...";\
       sed "s,@package@,$(PACKAGE),g;\
            s,@version@,$(VERSION),g;\
            s,@release@,$(RELEASE),g;\
            s,@frontend@,$(FRONTEND),g;\
            s,@pck_lib@,$(PACKAGE_LIB),g;\
            s,@pck_conf@,$(pck_conf),g;\
            s,@libdir@,$(libdir),g;\
            s,@sysconfdir@,$(sysconfdir),g;\
            s,@plugindir@,$(plugindir),g;\
            s,@templatedir@,$(templatedir),g;\
            s,@testdir@,$(testdir),g;\
            s,@date@,`LC_ALL="C" date "+%a %b %d %Y"`,g;\
            s,@date_my@,`LC_ALL="C" date "+%B %Y"`," $< > $@

all: dist-update locales check

check: dist-update
	@echo "Checking libraries and scripts for syntax errors..."
	@$(MAKE) check -C plugins || exit 1
	@$(MAKE) check -C tests || exit 1
	@$(MAKE) check -C tools || exit 1

dist-update: $(pck_infiles:.in=)

locales:
	@for loc in $(LOCALES); do\
	   $(MAKE) -C po/$$loc || exit 1;\
	done

install-frontend: $(PACKAGE) $(pck_conf)
	@echo "Installing frontend..."
	@$(INSTALL_DIR) $(DESTDIR)$(bindir)
	$(INSTALL_SCRIPT) $(PACKAGE) $(DESTDIR)$(bindir)/$(PACKAGE)
	@echo "Installing configuration file..."
	@$(INSTALL_DIR) $(DESTDIR)$(sysconfdir)
	$(INSTALL_DATA) $(pck_conf) $(DESTDIR)$(sysconfdir)/$(pck_conf)

install-libs: $(pck_libs)
	@echo "Installing libraries..."
	@$(MAKE) install -C lib || exit 1

install-locales: locales
	@echo "Installing localization files..."
	@for loc in $(LOCALES); do\
	   $(MAKE) install -C po/$$loc || exit 1;\
	done

install-manpages: $(pck_manpages)
	@echo "Installing manpages..."
	@for loc in $(LOCALES); do\
	   $(MAKE) install -C man/$$loc || exit 1;\
	done

install-plugins: $(pck_plugins)
	@echo "Installing plugins..."
	@$(MAKE) install -C plugins || exit 1

install-templates: $(pck_templates)
	@echo "Installing templates..."
	@$(MAKE) install -C templates || exit 1

install-tests: $(pck_tests)
	@echo "Installing tests..."
	$(MAKE) install -C tests || exit 1

install-tools: $(pck_tools)
	@echo "Installing tools..."
	$(MAKE) install -C tools || exit 1

install: install-frontend \
         install-libs \
         install-manpages \
         install-plugins \
         install-templates \
         install-tests \
         install-tools \
         install-locales

uninstall:
	@echo "Uninstalling all the files..."
	rm -f $(DESTDIR)$(bindir)/$(PACKAGE)
	rm -f $(DESTDIR)$(sysconfdir)/$(pck_conf)
	@for f in $(pck_libs); do\
	   echo "rm -f $(DESTDIR)$(libdir)/$${f##*/}";\
	   rm -f $(DESTDIR)$(libdir)/$${f##*/};\
	done
	@for f in $(pck_plugins); do\
	   echo "rm -f $(DESTDIR)$(plugindir)/$${f##*/}";\
	   rm -f $(DESTDIR)$(plugindir)/$${f##*/};\
	done
	@for f in $(pck_templates); do\
	   echo "rm -f $(DESTDIR)$(templatedir)/$${f##*/}";\
	   rm -f $(DESTDIR)$(templatedir)/$${f##*/};\
	done
	@for f in $(pck_tests); do\
	   echo "rm -f $(DESTDIR)$(testdir)/$${f##*/}";\
	   rm -f $(DESTDIR)$(testdir)/$${f##*/};\
	done
	@for f in $(pck_tools); do\
	   echo "rm -f $(DESTDIR)$(tooldir)/$${f##*/}";\
	   rm -f $(DESTDIR)$(tooldir)/$${f##*/};\
	done
	@for loc in $(LOCALES); do\
	   $(MAKE) uninstall -C man/$$loc || exit 1;\
	   $(MAKE) uninstall -C po/$$loc || exit 1;\
	done

dist: clean
	@for f in ChangeLog NEWS; do\
	   case `sed 15q $$f` in \
	   *"$(VERSION)"*) : ;; \
	   *) \
	     echo "$$f not updated; not releasing" 1>&2;\
	     exit 1;; \
	   esac; \
	done
	@rm -f history/$(dist_archive)
	@echo "Creating the compressed tarball..."
	@$(INSTALL_DIR) history
	tar cf - --exclude=history -C .. $(distdir) |\
	   bzip2 -9 -c > history/$(dist_archive)

dist-rpm: dist $(PACKAGE).spec
	@echo "Creating rpm and srpm packages..."
	@rpm_name=$(PACKAGE)-$(VERSION)-$(RELEASE);\
	rpm_sourcedir=`rpm --eval=%{_sourcedir} 2>/dev/null`;\
	rpm_specdir=`rpm --eval=%{_specdir} 2>/dev/null`;\
	for d in $$rpm_sourcedir $$rpm_specdir; do\
	   [ -d "$$d" ] || \
	    { echo "not found: $$d" 1>&2; exit 1; };\
	done;\
	(cp -p history/$(dist_archive) $$rpm_sourcedir &&\
	 mv -f $(PACKAGE).spec $$rpm_specdir &&\
	 rpmbuild --clean -ba $$rpm_specdir/$(PACKAGE).spec) || exit 1
	@echo "All done. Enjoy using $(PACKAGE)..."

clean: mostlyclean
	rm -f history/$(dist_archive)

mostlyclean:
	@echo "Cleaning up unpackaged files..."
	@$(MAKE) clean -C lib || exit 1
	@$(MAKE) clean -C plugins || exit 1
	@$(MAKE) clean -C templates || exit 1
	@$(MAKE) clean -C tests || exit 1
	@$(MAKE) clean -C tools || exit 1
	@for loc in $(LOCALES); do\
	   $(MAKE) clean -C man/$$loc || exit 1;\
	   $(MAKE) clean -C po/$$loc || exit 1;\
	done

