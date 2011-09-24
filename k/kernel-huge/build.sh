#!/bin/bash
set -e
set -u

CWD=$(pwd)
KVERSION=${VERSION:-"2.6.32.42"}
KERNNAME=${KERNNAME:-"huge"}
NUMJOBS=${NUMJOBS:-"-j7"}

if [ ! -e $CWD/linux-${KERNNAME}-${KVERSION}.config ]; then
	echo "Kernel config not found."
	exit 1;
fi

cd /usr/src/
tar vjxf $CWD/linux-${KVERSION}.tar.bz2 || exit 1
cd linux-${KVERSION} || exit 2
make clean
cp $CWD/linux-${KERNNAME}-${KVERSION}.config .config || exit 3

make ${NUMJOBS} || make || exit 10

make modules || exit 20

cd $CWD
VERSION=${KVERSION}
export VERSION
./kernel-${KERNNAME}.SlackBuild || exit $?

