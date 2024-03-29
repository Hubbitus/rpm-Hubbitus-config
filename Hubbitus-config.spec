Name:		Hubbitus-config
Version:		1
Release:		38%{?dist}
Summary:		Hubbitus system configuration
Summary(ru):	Настройки системы Hubbitus

Group:		System Environment/Base
License:		GPLv2+
URL:			http://rpm.hubbitus.info/
Source0:		.screenrc
Source1:		.screenrc-remote
Source2:		.toprc
Source3:		.rpmmacros
Source5:		.bash_profile
Source6:		.bashrc
Source7:		.rsync_shared_options
Source8:		.gitconfig

Source50:		root.screenrc
Source51:		root.toprc
Source52:		root.bashrc

BuildArch:	noarch
Requires:		Hubbitus-release
Requires:		screen, mc, bash-completion, colorize, git, ferm, wireshark-cli
Requires:		iotop, moreutils, grin, sshfs, htop, darkstat, glances
# dstat usefull but pull also PCP dependency which may look redundant
Requires:		strace, sysstat, psmisc, nethogs, telnet, elmon, trafshow
Requires:		the_silver_searcher, bind-utils, ncdu, vcsh
Requires:		java-1.8.0-openjdk-headless, multitail, rsync, mutt
# Request for epel7 was: https://bugzilla.redhat.com/show_bug.cgi?id=1141182
Requires:		bmon
# Request for epel7 was: https://bugzilla.redhat.com/show_bug.cgi?id=1141199
Requires:		atop
# Request for epel7 https://bugzilla.redhat.com/show_bug.cgi?id=1228747
Requires:		afuse
Requires(pre):	/usr/sbin/useradd
# Really it is provided by coreutils (/usr/bin/basename).
# But old Adobe Acrobat Rader require /bin/basename and symlink ignored
# Instead of manually deal with dependencies (https://www.if-not-true-then-false.com/2010/install-adobe-acrobat-pdf-reader-on-fedora-centos-red-hat-rhel/) I just add it there
Provides:		/bin/basename

%description
My initially settings of new system.
Mostly it contain Requires of useful packages and some settings.
Also creates pasha user without password but with access by keys.
THIS PACKAGE DOES NOT INTENDED FOR FOREIGN USE, but may be good idea to start
customize it for you own needs.

%description -l ru
Мои основные настройки новой системы.
Прежде всего пакет содержит зависимости к другим пакетам, которые я считаю
необходимыми, но также ещё некоторые настройки и скрипты.
ПАКЕТ НЕ ПРЕДНАЗНАЧЕН ДЛЯ ВНЕШНЕГО ИСПОЛЬЗОВАНИЯ, но может стать хорошим стартом
для создания подобного для своих нужд.

%package gui
Group:		System Environment/Base
Summary:		Hubbitus system configuration
Requires:		%{name} = %{version}-%{release}
Requires:		firefox, thunderbird, gajim, meld, yakuake, gxneur, terminator
Requires:		wireshark, mplayer

%description gui
My initially settings of new system with GUI.
Mostly it contain Requires of useful packages and some settings.
THIS PACKAGE DOES NOT INTENDED FOR FOREIGN USE, but may be good idea to start
customize it for own needs.

%description -l ru gui
Мои основные настройки новой системы c ГРАФИКОЙ.
Прежде всего пакет содержит зависимости к другим пакетам, которые я считаю
необходимыми, но также ещё некоторые настройки и скрипты.
ПАКЕТ НЕ ПРЕДНАЗНАЧЕН ДЛЯ ВНЕШНЕГО ИСПОЛЬЗОВАНИЯ, но может быть хорошим стартом
для создания подобного для себя.

%prep
%setup -c -T

%build

%install
rm -rf %{buildroot}

install -dm 755 %{buildroot}{/home/_SHARED_,/home/pasha/bin,/root/bin,/home/pasha/.ssh,/root/.ssh}

install -pm 644 %{SOURCE0} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE1} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE2} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE3} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE5} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE6} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE7} %{buildroot}/home/pasha/
install -pm 644 %{SOURCE8} %{buildroot}/home/pasha/

install -pm 644 %{SOURCE8} %{buildroot}/root/
install -pm 644 %{SOURCE50} %{buildroot}/root/.screenrc
install -pm 644 %{SOURCE51} %{buildroot}/root/.toprc
install -pm 644 %{SOURCE52} %{buildroot}/root/.bashrc.hubbitus


%clean
rm -rf %{buildroot}

%pre
# Add the "pasha" user
/usr/sbin/useradd pasha 2>/dev/null || :

%post
function git_up(){
	[ -e "$2/.svn" ] && rm -rf "$2" # migration from SVN
	# git -C "$2" pull --strategy=recursive || git clone "$1" "$2"
	# Unfortunately git 1.8 (on epel7) does not known -C option, workaround
	mkdir -p "$2" ; pushd "$2"
	git pull --strategy=recursive 2>/dev/null || git clone "$1" .
	popd
}

# Checkout ~/bin
git_up 'https://github.com/Hubbitus/shell.scripts.git' '/home/pasha/bin'
chown pasha -R /home/pasha/bin
git_up 'https://github.com/Hubbitus/shell.scripts.git' '/root/bin'

# Add once addon root .bashrc
grep -q hubbitus /root/.bashrc || echo -e '\n[ -f /root/.bashrc.hubbitus ] && . /root/.bashrc.hubbitus' >> /root/.bashrc

%files
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.screenrc
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.screenrc-remote
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.toprc
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.rpmmacros
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.bash_profile
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.bashrc
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.rsync_shared_options
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/.gitconfig
%attr(-,pasha,pasha) %config(noreplace) /home/pasha/bin
%config(noreplace) /root/.gitconfig
%config(noreplace) /root/.screenrc
%config(noreplace) /root/.toprc
%config(noreplace) /root/.bashrc.hubbitus
%config(noreplace) /root/bin
%dir %attr(0700,pasha,pasha) %config(noreplace) /home/pasha/.ssh
/home/_SHARED_

%files gui

%changelog
* Sun Nov 26 2023 Pavel Alexeev <Pahan@Hubbitus.info> - 1-38
- Build for Fedora 38

* Wed Feb 26 2020 Pavel Alexeev <Pahan@Hubbitus.info> - 1-36
- Add 'Provides: /bin/basename' for old Acrobat reader
- For GUI deps replace kdeneur by gxneur
- Dstat usefull but pull also PCP dependency which may look redundant. Excluding.
- Replase wireshark by wareshark-cli dependency and wireshark-gnome by wareshark

* Mon Jan 14 2019 Pavel Alexeev <Pahan@Hubbitus.info> - 1-35
- Drop authorized_keys from installation
- Big update of others config
- Drop php and svn with kde-dev-scripts requirements and HuPHP framework installation

* Wed Jul 15 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-34
- Add R mutt, fix root bashrc addition
- Update root .bashrc to handle missing mc modarin256root-defbg theme and fallback on gotar

* Wed Jul 08 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-32
- Add R rsync

* Tue Jun 30 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-32
- Add R multitail

* Mon Jun 29 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-31
- Add R kdeneur, yakuake, terminator to gui sub package

* Mon Jun 29 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-30
- Add /pasha/.gitconfig and /root/.gitconfig

* Mon Jun 29 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-29
- Add R vcsh, kde-dev-scripts (colorsvn)
- Add R java-1.8.0-openjdk-headless, java-1.8.0-openjdk-devel
- Remove R java-1.7.0-openjdk from gui sub package

* Wed Jun 17 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-28
- Add "chown pasha -R /home/pasha/bin"

* Fri Jun 05 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-27
- Add R ncdu, afuse

* Sun Mar 29 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-26
- Add R bind-utils (host command)

* Sat Mar 28 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-25
- Cleanup root.bashrc file.

* Sat Mar 28 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-24
- /root/.bashrc present in rootfiles package, so, deploy addon instead of conflict

* Sat Mar 28 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-23
- Include root.bashrc.
- Add R trafshow, the_silver_searcher(ag) and php.
- Remove R subversion (but leave in Requires(post))
- Move glances R from -gui sub-package to main.
- Update authorized_keys to mention more my servers (ansible will come to replacee it).

* Thu Mar 26 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-22
- In .bashrc conditionaly include /opt/grails/grails_autocomplete only if it exists.

* Fri Mar 06 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-21
- Change check of svn to just dir .svn presence, to do not play with its versions and upgrades

* Fri Mar 06 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-20
- Update git-up function with workaround to handle old 1.8 git on epel, which has not known -C option.

* Fri Mar 06 2015 Pavel Alexeev <Pahan@Hubbitus.info> - 1-19
- Add R telnet, elmon

* Tue Dec 16 2014 Pavel Alexeev <Pahan@Hubbitus.info> - 1-18
- Add R nethogs.

* Fri Oct 24 2014 Pavel Alexeev <Pahan@Hubbitus.info> - 1-17
- Add R psmisc.

* Fri Sep 12 2014 Pavel Alexeev <Pahan@Hubbitus.info> - 1-16
- Disable as it is not awailable for epel7:
# https://bugzilla.redhat.com/show_bug.cgi?id=1141182
#Requires:	bmon
# https://bugzilla.redhat.com/show_bug.cgi?id=1141199
#Requires:	atop
- Add R darkstat.

* Wed Apr 16 2014 Pavel Alexeev <Pahan@Hubbitus.info> - 1-15.2
- Add -C option in git, add --strategy=recursive option.

* Tue Apr 15 2014 Pavel Alexeev <Pahan@Hubbitus.info> - 1-15.1
- Migrate also bin-scripts from private svn to github git repository. Unify root and not-root.
- Drop svn repos support.

* Mon Apr 14 2014 Pavel Alexeev <Pahan@Hubbitus.info> - 1-14
- Migrate HuPHP framework from private svn to git repo on github.
- Bump version to 1-14

* Tue Oct 4 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-12
- Add .rsync_shared_options

* Mon Oct 3 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-11
- Add strace to dep.

* Sun Oct 2 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-10
- Correct files owner (pasha).
- Remove httpd-itk dependency.

* Wed Jun 15 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-9
- Add .screenrc-remote

* Tue Jun 7 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-8
- Add R atop, iotop

* Mon Jun 6 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-7
- Add R sshfs

* Fri May 6 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-6
- Add R grin

* Fri Mar 11 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-5
- Add R ferm
- Add R in gui - java-1.6.0-openjdk-plugin
- Add wireshark and wireshark-gnome in appropriate packages.

* Tue Mar 8 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-4
- Add R moreutils.
- Add Requires: firefox, thunderbird, gajim, meld into GUI subpackage.
- Add empty "%%files gui" section to generate subpackage.

* Tue Mar 8 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-3
- Silence user add if they exists.

* Tue Mar 8 2011 Pavel Alexeev <Pahan@Hubbitus.info> - 1-2
- Add pasha .bash_profile and .bashrc
- Update svn repos if they checkouted.

* Thu Sep 10 2009 Pavel Alexeev <Pahan@Hubbitus.info> - 1-1
- Initial release.
