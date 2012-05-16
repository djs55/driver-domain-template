#!/bin/sh

# Take a clean CentOS install and install the necessary packages
# to be able to run "make-initrd.sh"

set -e
set -x

echo Installing base packages from upstream
yum install gzip kernel autoconf automake make gcc -y

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
git clone git://github.com/libguestfs/febootstrap.git
(cd febootstrap; sh autogen.sh && ./configure && make)
echo XXX need to patch embedded python
