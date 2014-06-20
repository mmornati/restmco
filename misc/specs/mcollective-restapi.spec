Name: mcollective-restapi
Summary: A simple REST server used to communicate with Mcollective 
Version: 3.2
Release: 1%{?dist}
License: GPLv3
Group: System Tools 
Source0: %{name}-%{version}.tar.gz 
Requires: rubygem-daemons, rubygem-sinatra, mcollective-common, rubygem-inifile, rubygem-puma
%if "%dist" == ".el5"
Requires: selinux-policy-devel
%else 
Requires: selinux-policy
%endif
BuildRoot: %{_tmppath}/%{name}-%{version}-root
BuildArch: noarch

%description
A simple REST server in ruby and sinatra, used to communicate with Mcollective 

%prep
%setup -n %{name}

%build

%install
rm -rf %{buildroot}
install -d -m 755 %{buildroot}/usr/share/mcollective-restapi
install -d -m 755 %{buildroot}/etc/init.d
install -d -m 755 %{buildroot}/etc/mcollective-restapi
install -d -m 755 %{buildroot}/var/log
install app.rb %{buildroot}/usr/share/mcollective-restapi
install config.ru %{buildroot}/usr/share/mcollective-restapi
install puma.rb %{buildroot}/usr/share/mcollective-restapi
%{__cp} -R helpers %{buildroot}/usr/share/mcollective-restapi
%{__cp} -R routes %{buildroot}/usr/share/mcollective-restapi


install misc/service/mcollective-restapi %{buildroot}/etc/init.d 
install misc/sysconfig/mcollective-restapi.cfg %{buildroot}/etc/mcollective-restapi

%clean
rm -rf %{buildroot}

%pre
#mkdir -p /usr/local/bin/kermit/restmco

%files
%defattr(0644,root,root,-)
%attr(0755, root, root) /usr/share/mcollective-restapi
/usr/share/mcollective-restapi/app.rb
/usr/share/mcollective-restapi/puma.rb
/usr/share/mcollective-restapi/config.ru
/usr/share/mcollective-restapi/helpers/*
/usr/share/mcollective-restapi/routes/*
%attr(0755,root,root) /etc/init.d/mcollective-restapi
%config(noreplace) %attr(0755,root,root) /etc/mcollective-restapi/mcollective-restapi.cfg

%changelog
* Thu Jun 19 2014 Marco Mornati
- Code Refactor: allow restmco module
- Name Refactor: use restmco outside KermIT Env
* Sun Nov 11 2012 Louis Coilliot
- new method for calling mco rpcclient
* Thu Nov 8 2012 Marco Mornati
- Changes to use Makefile to build
* Fri Oct 26 2012 Marco Mornati
- Requires for selinux
* Fri Oct 26 2012 Louis Coilliot
- patch for JSON.dump compat with rb 1.8.7
* Fri Oct 26 2012 Louis Coilliot
- mco agent filter
* Thu Oct 25 2012 Louis Coilliot
- provide script for applying selinux conf
- proper display of filter arrays in the logs
* Wed Oct 24 2012 Louis Coilliot
- provide selinux module 
* Wed Oct 24 2012 Louis Coilliot
- simplified installation for passenger
* Mon Oct 22 2012 Marco Mornati
- Changed request type from GET to POST with a JSON Body Object for all
  parameters
- Created log file configurable with /etc/kermit/kermit-restmco
* Fri Nov 11 2011 Louis Coilliot
- identity_filter=host01_OR_host02 
* Mon Oct 24 2011 Louis Coilliot
- fixed problem with multiple options
* Wed Aug 24 2011 Louis Coilliot 
- fixed problem with limit filter
* Sat Aug 20 2011 Louis Coilliot
- credits and improved comments
* Thu Aug 18 2011 Louis Coilliot
- enable multiple filters in one request
* Thu Aug 18 2011 Louis Coilliot
- Initial build

