#!/bin/bash
set -e
set -u

CWD=$(pwd)
KVERSION=${KVERSION:-"2.6.32.42"}
KERNNAME=${KERNNAME:-"huge-v4l"}
NUMJOBS=${NUMJOBS:-"-j7"}
export KERNNAME

if [ ! -e $CWD/linux-${KERNNAME}-${KVERSION}.config ]; then
	echo "Kernel config not found."
	exit 1;
fi

cd /usr/src/
tar vjxf $CWD/linux-${KVERSION}.tar.xz || exit 1
cd linux-${KVERSION} || exit 2
make clean
cp $CWD/linux-${KERNNAME}-${KVERSION}.config .config || exit 3

make ${NUMJOBS} || make || exit 10

make modules || exit 20

cd $CWD
VERSION=${KVERSION}
export VERSION
./kernel-${KERNNAME}.SlackBuild || exit $?

unset KERNNAME

