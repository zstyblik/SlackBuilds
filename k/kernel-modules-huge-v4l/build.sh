#!/bin/bash
set -e
set -u

CWD=$(pwd)
KVERSION=${KVERSION:-"2.6.32.42"}
KERNNAME=${KERNNAME:-"huge-v4l"}
NUMJOBS=${NUMJOBS:-"-j7"}

cd /usr/src/linux-${KVERSION} || exit 2

make modules || exit 20

# save original modules, if any
if [ -d "/lib/modules/${KVERSION}" ]; then
	mv /lib/modules/${KVERSION}{,.org} || exit 25
fi;

make modules ${NUMJOBS} || make modules || exit 20
make modules_install || exit 30

cd "${CWD}"
VERSION="${KVERSION}"
export VERSION
# ToDo: KERNNAME ???
./kernel-modules-v4l.SlackBuild || exit $?

#mkdir -p $TMP/kernel-${FOO}-modules/lib/modules/
#mv /lib/modules/${VERSION} $TMP/kernel-${FOO}-modules/lib/modules/

# clean-up; recover modules
if [ -d "/lib/modules/${KVERSION}.org" ]; then
	rm -rf "/lib/modules/${KVERSION}"
	mv /lib/modules/${KVERSION}{.org,} || exit 35
fi

### HAXX - ToDo ###
PKG=$(ls /tmp/kernel-modules-v4l-${KVERSION}*.txz)
PKGNEW=$(echo "${PKG}" | sed -e "s#v4l-${KVERSION}#${KERNNAME}-${KVERSION}#")
PKGMD5=$(ls /tmp/kernel-modules-v4l-${KVERSION}*.md5)
PKGMD5NEW=$(echo "${PKGMD5}" | sed -e "s#v4l-${KVERSION}#${KERNNAME}-${KVERSION}#")

mv "${PKG}" "${PKGNEW}"
mv "${PKGMD5}" "${PKGMD5NEW}"
