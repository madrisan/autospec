autospec suite for *openmamba GNU/Linux*
========================================

## Overview

`Autospec` is a fully configurable suite of shell scripts for automatically generating specfiles from source tarballs and
downloading, upgrading, compiling, testing, and uploading the `rpm` (*RedHat Package Manager*) packages provided by an
rpm-based Linux distribution.

Autospec was created for the `QiLinux` distribution and is now used by the [openmamba](http://www.openmamba.org) developers.

## Architecture

#### Frontend
 * /usr/bin/autospec

#### Plugins (/usr/bin)
 * pck-extract - Extract a given file or list of files from a srpm archive
 * pck-update - Update a rpm package to a specified version and release
 * spec-create - Create a specfile for the specified source tarball
 * config-getvar - Print the value of a given configuration variable

#### Libraries (/usr/share/autospec/lib)
 * libapse.lib - Autospec Package Search Engine library
 * libcfg.lib - Load the configuration files
 * libmsgmng.lib - Manage debug/warning/error messages
 * libspec.lib - Specfiles parser
 * libtest.lib - Autospec library used by the test framework
 * libtranslate.lib - Autospec library used to setup translations
 * librepository.lib - Interact with the distribution repositories

#### Tests (/usr/share/autospec/tests)
 * test00_specsyntax - Syntax checks of a specfile
 * test01_pkgquality - RPM quality checks
 * test02_pkgsecurity - RPM security checks

#### Templates (/usr/share/autospec/templates)
 * ghc
 * gnome
 * kde3, kde4, kde5
 * library
 * ocaml-libs
 * perl
 * python
 * standard
 * standard-daemon
 * web

#### Configuration files
 * /etc/autospec.conf
 * /etc/autospec.d/*.conf
 * $HOME/.autospec
 * $HOME/.autospec.d/*.conf

#### Color Scheme files
 * /etc/autospec.d/color-theme.*

#### Translation files (/usr/share/locale/it/LC_MESSAGES/)
 * po files

## Get it, Try it, Love it...

Install autospec in openmamba by entering the following command in the terminal prompt:

    smart install autospec

or

    yum install --nogpgcheck autospec

if you already switched to yum.

## Bugs

If you find a bug please create an issue in the project bug tracker at
[openmamba GitLab](https://gitlab.mambasoft.it/openmamba/autospec/issues).
