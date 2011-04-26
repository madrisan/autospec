# this is a comment
# and now another comment

# this string should be skipped by sintax tests : _infodir

%define with_contrib 1
%define use_gcc_33   0
%define use_ccache   1
%define mbaddons_ver 1.2.3
#%define dailyver %(date +%d%m_%y)
%define with_gui     1
%define always_true  1

%define majorminor %(echo %version | cut -d. -f 1-2)

## *AUTOSPEC-OFF*
%define not_a_as_definition a_test
## *AUTOSPEC-ON*

%define target_cpu %{_target_cpu}

%if ! %{use_gcc_33}
%if %always_true
%if %use_ccache
%define BUILD_CC "ccache gcc"
%else
%define BUILD_CC "gcc"
%endif
%endif
%else
%if %use_ccache
%define BUILD_CC "ccache gcc33"
%else
%define BUILD_CC "gcc33"
%endif
%endif

%if "%{?stage1}"
%define notadef "nad"
%endif

Summary: A MIB browser based on net-snmp and GTK+
Name : mbrowse
Version: 0.3.1
Release: 2006.1.5qilnx
Epoch: 1
Group: Network/Monitoring
Vendor:        QiLinux
Packager:      Davide Madrisan <davide.madrisan@qilinux.it>
BuildRoot:     %{_tmppath}/%{name}-%{version}-root
Url:           http://goldplated.atlcartel.com
Source:	http://www.awebsiteintheworld.org/%{name}/%{majorminor}/%{name}-%{version}.tar.gz
#Source1:	ftp://ftp.ftpsomewhere.net/mbrowse-2/contrib/mbrowse-contrib-%{version}.tar.bz2
#Source2:	http://www.website.va/download/mbrowse_addons-%{mbaddons_ver}.tar.bz2
#Source3:	alocalfile.sh
Patch0:        %{name}-0.3.1-config.patch.bz2
Patch1:        %{name}-0.3.1-gcc34.patch.gz
Patch2:        nonstandardname_mbrowse-0.3.1-gcc34.patch
#Patch3:        http://www.awebsiteintheworld.org/awebpatch-%{version}.patch
BuildRequires: net-snmp-devel >= 4.2
BuildRequires: libopenssl-devel
Requires(post):%{__install_info}
%if %with_gui
BuildRequires: libgtk1-devel >= 1.2.10
#BuildRequires: libglib2-devel >= 2.1.5
BuildRequires: libglib1-devel >= 1.2.10
BuildRequires: zlib-devel >= 1.2.3
%endif
Requires:      exists(/bin/bash)
License:       GPL, LGPL , zlib/libpng License

# yet another comment

%description
This package is a MIB browser based on net-snmp and GTK+.
Blah blah.

%if %with_contrib
%package contrib
Summary:       Just added to test autospec
#Group:         Network/Monitoring/Users Contrib
Group:         Network/Monitoring
#BuildArch:     noarch
Requires:      %{name} = %{?epoch:%epoch:}%{version}-%{release}
## *AUTOSPEC-OFF*
Obsoletes: %{name}-extratools
## *AUTOSPEC-ON*
Obsoletes: %{name}-extra
Obsoletes: %{name}-tools

%description contrib
Contributor scripts for %{name}.
%endif

%prep
%setup -q
%patch0 -p1 -b .config
%patch1 -p1 -b .gcc34

%build
%configure

#% define BUILD_CC   %{_target_platform}-gcc
#% define BUILD_CXX  %{_target_platform}-g++
#
#% define USE_DISTCC 0
#
#% if %{USE_DISTCC}
#% define DISTCC_CC   ccache distcc %{?BUILD_CC}
#% define DISTCC_CXX  ccache distcc %{?BUILD_CXX}
#% define BUILD_OPTS  CC="%{DISTCC_CC}" CXX="%{DISTCC_CXX}" -j1
#% else
#% define BUILD_OPTS  CC="%{BUILD_CC}" CXX="%{BUILD_CXX}" %{_smp_mflags}
#% endif
#
#make %{BUILD_OPTS}

## *AUTOSPEC-OFF*
%ifarch ppc
echo "arch is ppc..."
%endif
## *AUTOSPEC-ON*

%if "%{?debug}" == "1"
%make %{?BUILD_CC:CC=%BUILD_CC} CFLAGS="-Wall -g"
%else
%make %{?BUILD_CC:CC=%BUILD_CC}
%endif

%install
[ "%{buildroot}" != / ] && rm -rf "%{buildroot}"
%makeinstall

# REMOVE!
install -d %{buildroot}%{_infodir}
touch %{buildroot}%{_infodir}/mbrowse.info

rm -f %{buildroot}%{_datadir}/phantom.tmp

install -d %{buildroot}%{_sysconfdir}
touch %{buildroot}%{_sysconfdir}/mbrowse.conf

echo "\
!#/bin/bash

tempf=$$
rm -f $temp
" >> %{buildroot}%{_bindir}/badscript

install -d %{buildroot}%{_datadir}/locale/it_IT/LC_MESSAGES
touch %{buildroot}%{_datadir}/locale/it_IT/LC_MESSAGES/%{name}.mo

%find_lang %{name}

%clean
[ "%{buildroot}" != / ] && rm -rf "%{buildroot}"

%post
%install_info mbrowse.info

%preun
%uninstall_info mbrowse.info

%files -f %{name}.lang
%defattr(-,root,root)
%attr(2755,root,root) %{_bindir}/mbrowse
%{_bindir}/badscript
%_infodir/mbrowse.*
# /usr/include/info/mbrowse.*
#%{_mandir}/man8/mbrowse.*
#%{_mandir}/fr/man8/mbrowse-fr.*
#%{_datadir}/locale/*
%config %{_sysconfdir}/mbrowse.conf
%doc AUTHORS COPYING ChangeLog NEWS README TODO

%if %with_contrib
%if %{target_cpu} == %{_build_cpu}
%files contrib
%defattr(-,root,root)
%doc AUTHORS
%endif
%endif

#%files -f XXX -n contrib2
#%defattr(-,root,root)
#%doc CONTRIB-TWO

%changelog
* Wed Dec 29 2004 Davide Madrisan <davide.madrisan@qilinux.it> 0.3.1-1qilnx
- package created by autospec
