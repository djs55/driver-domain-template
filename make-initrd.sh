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

FEBOOTSTRAP_OUTPUT=$(pwd)/$(mktemp -d febootstrap.XXXXXX)
echo "Using febootstrap to add \"$*\" (and \"bash\" for debugging)"
${FEBOOTSTRAP} --names bash $* -o ${FEBOOTSTRAP_OUTPUT}
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

OUTPUT=$(pwd)/initrd
echo Repacking into ${OUTPUT}
(cd ${ROOT}; find . | cpio -o -Hnewc | gzip -9c > ${OUTPUT})
echo Cleaning up
rm -rf ${FEBOOTSTRAP_OUTPUT}
