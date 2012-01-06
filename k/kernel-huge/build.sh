#!/bin/bash
set -e
set -u

CWD=$(pwd)
KVERSION=${VERSION:-"2.6.32.42"}
KERNNAME=${KERNNAME:-"huge"}
NUMJOBS=${NUMJOBS:-"-j7"}

if [ ! -e $CWD/linux-${KERNNAME}-${KVERSION}.config ]; then
	echo "Kernel config not found."
	exit 1
fi

cd /usr/src/
if [ ! -e "linux-${KVERSION}.tar.bz2" ]; then
	KVERPART=$(printf "%s" "${KVERSION}" | cut -d '.' -f 1-2)
	if [ -z "${KVERPART}" ] || ! printf "%s" "${KVERPART}" | grep -e '[0-9]\.[0-9]'; then
		printf "KVERSION '%s' is garbage. Expected X.Y.Z...\n" "${KVERSION}"
		exit 1
	fi # if [ -z "${VERPART}" ]
	if printf "%s" "${KVERPART}" | grep -q -e '3\.[0-9]' ; then
		# Note: Let's see when this is going to break
		KVERPART="3.0"
	fi
	wget \
		"http://www.kernel.org/pub/linux/kernel/v${KVERPART}/linux-${KVERSION}.tar.bz2"
fi # if [ ! -e "linux-${KVERSION}.tar.bz2" ]
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

