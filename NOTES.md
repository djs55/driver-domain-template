
Approach
========

  1. Use febootstrap on CentOS to make a supermin appliance
  2. Use febootstrap-supermin-helper to create a fat initrd

Notes
=====

./install_centos.sh <hostname> <password>
(log in)
create non-root account
  vigr add to wheel (including shadow)
  visudo enable wheel

yum install kernel # to make febootstrap happy

wget http://git-core.googlecode.com/files/git-1.7.10.2.tar.gz
tar -xvfz git-1.7.10.2.tar.gz
cd git-1.7.10.2
./configure
make
sudo make install
cd ~
git clone git://github.com/libguestfs/febootstrap.git
wget http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.1.tar.bz2
tar -xvjf ocaml-3.12.1.tar.bz2
cd ocaml-3.12.1
./configure
make world.opt
make install
cd ~
wget http://download.camlcity.org/download/findlib-1.3.1.tar.gz
tar -xvzf findlib-1.3.1.tar.gz
cd findlib-1.3.1
make all opt
sudo make install
cd ~
cd febootstrap
sh autogen.sh
./configure
# XXX need to patch embedded python
make
mkdir /tmp/centos
sudo ./src/febootstrap --names bash -o /tmp/centos
cd ..
mkdir /tmp/appliance
# febootstrap-supermin-helper failed by concatenating two cpio archives, leaving us
# with two "TRAILER!!" records.
mkdir /tmp/appliance/root
(cd /tmp/appliance/root; cpio -id < /tmp/centos/base.img)
(cd /tmp/appliance/root; cat /tmp/centos/hostfiles | ./expand-glob.py | cpio -pdumv .)
(cd /tmp/appliance/root; find . | cpio -o -H newc | gzip -9c > /tmp/appliance/initrd)
