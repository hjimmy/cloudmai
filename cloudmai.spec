Name:           cloudmai
Version:        1.0.0
Release:        1%{?dist}
Summary:        Cloud Storage Middle Access Interface

Group:          Applications/System
License:        LGPLv2+
URL:            http://www.ustb.edu.cn/
Source0:        %{name}/%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires:       owncloud owncloud-3rdparty mysql-server MySQL-python

%description
This is a rpm for Cloud Storage Middle Access Interface

%prep
tar xvf $RPM_SOURCE_DIR/%{name}-%{version}.tar.gz -C $RPM_BUILD_DIR/

%setup -q
%build

%install

mkdir -p $RPM_BUILD_ROOT/srv/cloudmai/
mkdir -p $RPM_BUILD_ROOT/root/Desktop
mkdir -p $RPM_BUILD_ROOT/root/桌面/


cp -rf $RPM_BUILD_DIR/%{name}-%{version}/config.php  $RPM_BUILD_ROOT/srv/cloudmai/
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/PasswordHash.php $RPM_BUILD_ROOT/srv/cloudmai/
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/userManager.py $RPM_BUILD_ROOT/srv/cloudmai/
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/user.php $RPM_BUILD_ROOT/srv/cloudmai/
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/init.sh $RPM_BUILD_ROOT/srv/cloudmai/
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/clean.sh $RPM_BUILD_ROOT/srv/cloudmai
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/owncloud.jpg $RPM_BUILD_ROOT/srv/cloudmai
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/owncloud.sql $RPM_BUILD_ROOT/srv/cloudmai

cp -rf $RPM_BUILD_DIR/%{name}-%{version}/StorageServer.Desktop $RPM_BUILD_ROOT/root/Desktop
cp -rf $RPM_BUILD_DIR/%{name}-%{version}/StorageServer.Desktop $RPM_BUILD_ROOT/root/桌面


%post

%preun

%clean
rm -rf %{buildroot}
%files
%defattr(-,root,root,-)
/srv/cloudmai/config.php
/srv/cloudmai/PasswordHash.php
/srv/cloudmai/userManager.py
/srv/cloudmai/user.php
/srv/cloudmai/init.sh
/srv/cloudmai/clean.sh
/srv/cloudmai/owncloud.jpg
/srv/cloudmai/owncloud.sql
/root/Desktop/StorageServer.Desktop
/root/桌面/StorageServer.Desktop

%exclude /srv/cloudmai/userManager.pyc
%exclude /srv/cloudmai/userManager.pyo

%doc
%changelog

