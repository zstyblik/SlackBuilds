#!/bin/bash
set -e
set -u

CWD=$(pwd)
KVERSION=${VERSION:-"2.6.32.42"}
KERNNAME=${KERNNAME:-"huge"}
NUMJOBS=${NUMJOBS:-"-j7"}

TMP=${TMP:-/tmp}
CWD=$(pwd)
PKG=$TMP/package-kernel-modules

rm -rf $PKG

cd /usr/src/linux-${KVERSION} || exit 2

make modules || exit 20

# save original modules, if any
if [ -d /lib/modules/${KVERSION} ]; then
	mv /lib/modules/${KVERSION}{,.org} || exit 25
fi;

make modules ${NUMJOBS} || make modules || exit 20
make modules_install INSTALL_MOD_PATH=${PKG} || exit 30

cd $CWD
VERSION=$KVERSION
export VERSION
./kernel-modules.SlackBuild || exit $?

#mkdir -p $TMP/kernel-${FOO}-modules/lib/modules/
#mv /lib/modules/${VERSION} $TMP/kernel-${FOO}-modules/lib/modules/

# clean-up; recover modules
if [ -d /lib/modules/${KVERSION}.org ]; then
	rm -rf /lib/modules/${KVERSION}
	mv /lib/modules/${KVERSION}{.org,} || exit 35
fi

