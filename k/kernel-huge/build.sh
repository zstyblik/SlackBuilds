#!/bin/bash
set -e
set -u

CWD=$(pwd)
KVERSION=${VERSION:-"2.6.32.42"}
KERNNAME=${KERNNAME:-"huge"}
NUMJOBS=${NUMJOBS:-"-j7"}
SOURCES=${SOURCES:-$(pwd)}

if [ ! -e $CWD/linux-${KERNNAME}-${KVERSION}.config ]; then
	printf "Kernel config '%s/linux-%s-%s.config' not \
found.\n" "${CWD}" "${KERNNAME}" "${KVERSION}"
	exit 1
fi

if [ ! -e "${SOURCES}/linux-${KVERSION}.tar.bz2" ]; then
	KVERPART=$(printf -- "%s" "${KVERSION}" | cut -d '.' -f 1-2)
	if [ -z "${KVERPART}" ] || ! printf "%s" "${KVERPART}" | grep -q -e '[0-9]\.[0-9]'; then
		printf "KVERSION '%s' is garbage. Expected X.Y.Z...\n" "${KVERSION}"
		exit 1
	fi # if [ -z "${VERPART}" ]
	if printf -- "%s" "${KVERPART}" | grep -q -e '3\.[0-9]' ; then
		# Note: Let's see when this is going to break
		KVERPART="3.0"
	fi
	wget --no-check-certificate \
		"http://www.kernel.org/pub/linux/kernel/v${KVERPART}/linux-${KVERSION}.tar.bz2"\
		-O "${SOURCES}/linux-${KVERSION}.tar.bz2"
fi # if [ ! -e "linux-${KVERSION}.tar.bz2" ]

cd /usr/src/
tar vjxf $SOURCES/linux-${KVERSION}.tar.bz2 || exit 1
cd linux-${KVERSION} || exit 2
make clean
cp $CWD/linux-${KERNNAME}-${KVERSION}.config .config || exit 3

make ${NUMJOBS} || make || exit 10

make modules || exit 20

cd $CWD
VERSION=${KVERSION}
export VERSION
./kernel-${KERNNAME}.SlackBuild || exit $?

