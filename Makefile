# Makefile for autospec
# Copyright (C) 2004-2008,2011,2012 by Davide Madrisan <davide.madrisan@gmail.com>

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

FRONTEND = $(PACKAGE)
PACKAGE_LIB = libspec.lib

LOCALES = it

srcdir = .

distdir = $(PACKAGE)-$(VERSION)
dist_archive = $(distdir).tar.bz2

DESTDIR =

pck_root := $(sort $(patsubst %.in,%,$(wildcard *.in)))
pck_confs := $(sort $(patsubst %.in,%,$(wildcard conf/*)))
pck_libs := $(sort $(patsubst %.in,%,$(wildcard lib/*)))
pck_manpages := $(patsubst %.in,%,$(wildcard man/*.in man/*/*.in))
pck_plugins := $(sort $(patsubst %.in,%,$(wildcard plugins/*)))
pck_templates := $(sort $(patsubst %.in,%,$(wildcard templates/*)))
pck_tests := $(sort $(patsubst %.in,%,$(wildcard tests/*)))
pck_tools := $(sort $(patsubst %.in,%,$(wildcard tools/*)))

pck_infiles := $(wildcard *.in conf/*.in lib/*.in man/*.in man/*/*.in plugins/*.in templates/.in tests/* tools/*.in)

.SUFFIXES:
.SUFFIXES: .in

.in:; @echo "Generating $@...";\
       sed "s,@package@,$(PACKAGE),g;\
            s,@version@,$(VERSION),g;\
            s,@release@,$(RELEASE),g;\
            s,@frontend@,$(FRONTEND),g;\
            s,@pck_lib@,$(PACKAGE_LIB),g;\
            s,@confdir@,$(confdir),g;\
            s,@libdir@,$(libdir),g;\
            s,@sysconfdir@,$(sysconfdir),g;\
            s,@plugindir@,$(plugindir),g;\
            s,@templatedir@,$(templatedir),g;\
            s,@testdir@,$(testdir),g;\
            s,@date@,`LC_ALL="C" date "+%a %b %d %Y"`,g;\
            s,@date_my@,`LC_ALL="C" date "+%B %Y"`," $< > $@

all: dist-update locales check pot-files

check: dist-update
	@echo "Checking libraries and scripts for syntax errors..."
	@$(MAKE) check -C conf || exit 1
	@$(MAKE) check -C lib || exit 1
	@$(MAKE) check -C plugins || exit 1
	@$(MAKE) check -C tests || exit 1
	@$(MAKE) check -C tools || exit 1

dist-update: $(pck_infiles:.in=)

pot-files: dist-update
	@echo "Creating pot files..."
	@echo "Generating po template '$(PACKAGE).pot'..."; \
	/usr/bin/xgettext -i -L shell \
	   --copyright-holder="$(PO_COPYRIGH_HOLDER)" \
	   --msgid-bugs-address="$(PO_BUGS_ADDRESS)" \
	   --no-location \
	   --package-name=$(PACKAGE) \
	   --package-version=${VERSION} \
	   $(PACKAGE) -o $(srcdir)/po/$(PACKAGE).pot 2>/dev/null
	@$(MAKE) pot-files -C lib || exit 1
	@$(MAKE) pot-files -C plugins || exit 1
	@$(MAKE) pot-files -C tests || exit 1

pot-merge: pot-files
	@$(MAKE) pot-merge -C po/it || exit 1

locales:
	@for loc in $(LOCALES); do\
	   $(MAKE) -C po/$$loc || exit 1;\
	done

locales-concatenate: locales pot-files
	@for loc in $(LOCALES); do\
	   $(MAKE) locales-concatenate -C po/$$loc || exit 1;\
	done

install-frontend: $(PACKAGE)
	@echo "Installing frontend..."
	@$(INSTALL_DIR) $(DESTDIR)$(bindir)
	$(INSTALL_SCRIPT) $(PACKAGE) $(DESTDIR)$(bindir)/$(PACKAGE)

install-confs: $(pck_confs)
	@echo "Installing configuration files..."
	@$(MAKE) install -C conf || exit 1

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
         install-confs \
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
	$(MAKE) uninstall -C conf
	$(MAKE) uninstall -C lib
	$(MAKE) uninstall -C plugins
	$(MAKE) uninstall -C templates
	$(MAKE) uninstall -C tests
	$(MAKE) uninstall -C tools
	@for loc in $(LOCALES); do\
	   $(MAKE) uninstall -C man/$$loc;\
	   $(MAKE) uninstall -C po/$$loc;\
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
	@$(INSTALL_DIR) history
	@echo "Creating a temporary copy of the entire repository..."
	@tmpdir=`mktemp -q -d -t $(PACKAGE)-dist.XXXXXXXX`;\
	[ $$? -eq 0 ] || \
	 { echo "cannot create a temporary directory"; exit 1; };\
	$(INSTALL_DIR) $$tmpdir/$(PACKAGE)-$(VERSION);\
	find . -mindepth 1 \( -name .git -o -name history \) \
	   -prune -o \( \! -name *~ -print0 \) | \
	   cpio --quiet -pmd0 $$tmpdir/$(PACKAGE)-$(VERSION)/;\
	currdir="`pwd`";\
	echo "Creating the compressed tarball...";\
	pushd $$tmpdir/$(PACKAGE)-$(VERSION)/ >/dev/null;\
	tar cf - -C .. $(PACKAGE)-$(VERSION) |\
	   bzip2 -9 -c > "$$currdir"/history/$(dist_archive);\
	[ -f "$$currdir/history/$(dist_archive)" ] && \
	   echo "Wrote: $$currdir/history/$(dist_archive)";\
	popd >/dev/null;\
	rm -fr $$tmpdir

dist-rpm: dist $(PACKAGE).spec
	@rpm_name=$(PACKAGE)-$(VERSION)-$(RELEASE);\
	rpm_sourcedir=`rpm --eval=%{_sourcedir} 2>/dev/null`;\
	rpm_specdir=`rpm --eval=%{_specdir} 2>/dev/null`;\
	for d in $$rpm_sourcedir $$rpm_specdir; do\
	   [ -d "$$d" ] || \
	    { echo "not found: $$d" 1>&2; exit 1; };\
	done;\
	echo "Copying $(dist_archive) to $$rpm_sourcedir...";\
	(cp -p history/$(dist_archive) $$rpm_sourcedir &&\
	 mv -f $(PACKAGE).spec $$rpm_specdir &&\
	echo "Creating rpm and srpm packages..." &&\
	rpmbuild --clean -ba $$rpm_specdir/$(PACKAGE).spec) || exit 1
	@echo "All done. Enjoy using $(PACKAGE)..."

dist-rpm-install: dist-rpm
	@echo "Installing rpm packages..."
	@rpm_pckdir=`rpm --eval=%{_rpmdir} 2>/dev/null`;\
	sudo rpm -hUv --force\
	   $$rpm_pckdir/noarch/$(PACKAGE)-*${VERSION}-${RELEASE}.noarch.rpm\
	   || exit 1

clean: mostlyclean
	rm -f history/$(dist_archive)

mostlyclean:
	@echo "Cleaning up unpackaged files..."
	@rm -f $(pck_root)
	@$(MAKE) clean -C conf || exit 1
	@$(MAKE) clean -C lib || exit 1
	@$(MAKE) clean -C plugins || exit 1
	@$(MAKE) clean -C templates || exit 1
	@$(MAKE) clean -C tests || exit 1
	@$(MAKE) clean -C tools || exit 1
	@for loc in $(LOCALES); do\
	   $(MAKE) clean -C man/$$loc || exit 1;\
	   $(MAKE) clean -C po/$$loc || exit 1;\
	done
	@rm -f po/*.pot

