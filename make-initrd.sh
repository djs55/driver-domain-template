#!/bin/sh

set -e
set -x

# Use febootstrap (driving "yum") to make a chroot and
# package this up as a bootable initrd. Note we also need
# a suitable kernel from somewhere.

FEBOOTSTRAP=$HOME/febootstrap/src/febootstrap

if [ ! -x "${FEBOOTSTRAP}" ]; then
  echo "You need to build febootstrap first. I was expecting to find it in: ${FEBOOTSTRAP}"
  exit 1
fi

EXPAND_GLOB=$HOME/driver-domain-template/expand-glob.py

if [ ! -x "${EXPAND_GLOB}" ]; then
  echo "You need expand-glob.py first. I was expecting to find it in: ${EXPAND_GLOB}"
  exit 1
fi

# Make sure the yum metadata cache exists
yum makecache

FEBOOTSTRAP_OUTPUT=$(pwd)/$(mktemp -d febootstrap.XXXXXX)
echo "Using febootstrap to add \"$*\""
${FEBOOTSTRAP} --names $* -o ${FEBOOTSTRAP_OUTPUT}
ROOT=${FEBOOTSTRAP_OUTPUT}/root
mkdir ${ROOT}

echo Unpacking base.img into ${ROOT}
(cd ${ROOT}; cpio -id < ${FEBOOTSTRAP_OUTPUT}/base.img)
echo Adding hostfiles into ${ROOT}
(cd ${ROOT}; cat ${FEBOOTSTRAP_OUTPUT}/hostfiles | ${EXPAND_GLOB} | cpio -pdumv .)

OVERLAY=$(pwd)/overlay
echo Looking for optional ${OVERLAY}
if [ -d ${OVERLAY} ]; then
  echo Copying overlay into ${ROOT}
  (cd ${OVERLAY}; find . | cpio -pdumv ${ROOT})
fi

MODULES=$(pwd)/modules.cpio
echo Looking for optional ${MODULES}
if [ -e ${MODULES} ]; then
  echo UNpacking modules into ${ROOT}
  (cd ${ROOT}; cpio -id < ${MODULES})
fi

FIRMWARE=$(pwd)/firmware.cpio
echo Looking for optional ${FIRMWARE}
if [ -e ${FIRMWARE} ]; then
  echo UNpacking firmware into ${ROOT}
  (cd ${ROOT}; cpio -id < ${FIRMWARE})
fi

OUTPUT=$(pwd)/initrd
echo Repacking into ${OUTPUT}
(cd ${ROOT}; find . | cpio -o -Hnewc | gzip -9c > ${OUTPUT})
echo Removing ${FEBOOTSTRAP_OUTPUT}
rm -rf ${FEBOOTSTRAP_OUTPUT}
