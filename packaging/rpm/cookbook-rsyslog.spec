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

requires: unzip

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

# Copy libraries to user
cp -f /var/chef/cookbooks/rsyslog/files/default/* /usr/lib64/rsyslog/
cd /usr/lib64/rsyslog/
unzip -f -j -o /usr/lib64/rsyslog/libraries.zip

#Cleaning temporally file
rm -f /usr/lib64/rsyslog/libraries.zip

%files
%defattr(0755,root,root)
%{rsys_lib}
%defattr(0755,root,root)
/var/chef/cookbooks/rsyslog
%defattr(0644,root,root)
/var/chef/cookbooks/rsyslog/README.md


%doc

%changelog
* Mon Nov 15 2021 Jordi Hernandez <jhernandez@redborder.com> - 1.0.1-1
- Corrected source cookbook template

* Fri Nov 12 2021 Javier Rodríguez <javiercrg@redborder.com> - 1.0.0-1
- first spec version
