%global rsys_lib /usr/lib64/rsyslog
%define _binaries_in_noarch_packages_terminate_build 0

Name: cookbook-rsyslog
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: rsyslog cookbook to install and configure it in redborder environments

License: AGPL 3.0
URL: https://github.com/redborder/cookbook-rsyslog
Source0: %{name}-%{version}.tar.gz

requires: unzip, wget

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rsyslog
mkdir -p %{buildroot}/usr/lib64/rsyslog

cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rsyslog/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rsyslog
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rsyslog/README.md

%pre
if [ -d /var/chef/cookbooks/rsyslog ]; then
    rm -rf /var/chef/cookbooks/rsyslog
fi

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rsyslog'
  ;;
esac

%postun
# Deletes directory when uninstall the package
if [ "$1" = 0 ] && [ -d /var/chef/cookbooks/rsyslog ]; then
  rm -rf /var/chef/cookbooks/rsyslog
fi

%files
%defattr(0755,root,root)
%{rsys_lib}
%defattr(0644,root,root)
%attr(0755,root,root)
/var/chef/cookbooks/rsyslog
%defattr(0644,root,root)
/var/chef/cookbooks/rsyslog/README.md


%doc

%changelog
* Thu Oct 10 2024 Miguel Negrón <manegron@redborder.com>
- Add pre and postun

* Fri Jan 07 2022 David Vanhoucke <dvanhoucke@redborder.com>
- change register to consul

* Mon Nov 15 2021 Jordi Hernandez <jhernandez@redborder.com>
- Corrected source cookbook template

* Fri Nov 12 2021 Javier Rodríguez <javiercrg@redborder.com>
- first spec version
