#!/bin/sh

# Take a clean CentOS install and install the necessary packages
# to be able to run "make-initrd.sh"

set -e
set -x

rm -f /etc/yum.repos.d/*.repo
cat <<EOT >/etc/yum.repos.d/builder.repo
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#

[base]
name=base
baseurl=http://ely.uk.xensource.com/CentOS/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#released updates 
[updates]
name=updates
baseurl=http://ely.uk.xensource.com/CentOS/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

# XCP-specific stuff
[extra]
name=extra
baseurl=http://ely.uk.xensource.com/extra
gpgcheck=0
EOT

yum clean all

cd /root
echo Installing base packages from upstream
yum install gzip kernel autoconf automake make gcc yum-utils -y

echo Downloading git
wget http://git-core.googlecode.com/files/git-1.7.10.2.tar.gz
tar -xvzf git-1.7.10.2.tar.gz
(cd git-1.7.10.2; ./configure && make && make install)

echo Building ocaml
wget http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.1.tar.bz2
tar -xvjf ocaml-3.12.1.tar.bz2
(cd ocaml-3.12.1; ./configure && make world.opt && make install)

echo Building findlib
wget http://download.camlcity.org/download/findlib-1.3.1.tar.gz
tar -xvzf findlib-1.3.1.tar.gz
(cd findlib-1.3.1; ./configure && make all opt && make install)

echo Building febootstrap
git clone git://github.com/djs55/febootstrap.git
(cd febootstrap; git checkout centos5)
(cd febootstrap; sh autogen.sh && ./configure && make)

echo Downloading scripts
git clone git://github.com/djs55/driver-domain-template.git

