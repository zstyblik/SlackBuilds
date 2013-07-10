#!/bin/bash
set -e
set -u

VERSION=${VERSION:-'v3.6c'}
ARCH=${ARCH:-$(uname -m)}
NUMJOBS=${NUMJOBS:-" -j7 "}
SOURCES=${SOURCES:-$(pwd)}
BUILD=${BUILD:-1}
AUTHOR=""
APPL='loop-AES'
TRSFX="tar.bz2"

CWD=$(pwd)
TMP=${TMP:-/tmp}
PKG="${TMP}/package-${APPL}"

KVERSION=${KVERSION:-'2.6.32.42'}
KERNNAME=${KERNNAME:-''}
#if [ ! -z "${KERNNAME}" ]; then
#	KVERSION="${KVERSION}-$(printf "%s" "${KERNNAME}" | cut -d '-' -f 2)"
#fi

VAR_LINUX_SOURCE="/usr/src/linux-${KVERSION}"
VAR_INSTALL_MOD_PATH="${TMP}/package-${APPL}"
NUMJOBS=${NUMJOBS:-"-j7"}

if [ ! -e "${SOURCES}/${APPL}-${VERSION}.${TRSFX}" ]; then
	wget --no-check-certificate \
		"http://loop-aes.sourceforge.net/loop-AES/${APPL}-${VERSION}.${TRSFX}" \
		-O  "${SOURCES}/${APPL}-${VERSION}.${TRSFX}"
fi

cd "${TMP}"

rm -Rf "${VAR_INSTALL_MOD_PATH}"
rm -Rf "${TMP}/${APPL}-${VERSION}"

tar vjxf "${SOURCES}/${APPL}-${VERSION}.${TRSFX}"
cd "${APPL}-${VERSION}"
make clean || exit 1
make INSTALL_MOD_PATH=${VAR_INSTALL_MOD_PATH} LINUX_SOURCE=${VAR_LINUX_SOURCE} \
	|| exit 2

cd "${VAR_INSTALL_MOD_PATH}"
find "${VAR_INSTALL_MOD_PATH}" -name modules.* -exec rm {} \;
mkdir "${VAR_INSTALL_MOD_PATH}/install" 2>/dev/null

cat "${CWD}/slack-desc" > "${VAR_INSTALL_MOD_PATH}/install/slack-desc" || \
	echo "slack-desc not found."

cat > "${VAR_INSTALL_MOD_PATH}/install/doinst.sh"<<EOD
if [ -x sbin/depmod ]; then
	chroot . /sbin/depmod -a "${KVERSION}" >/dev/null 2>&1
fi
EOD

makepkg -l y -c n "${TMP}/${APPL}-${VERSION}-${KVERSION}${KERNNAME}-${ARCH}-${BUILD}.txz"

pushd "${TMP}"
MD5SUM=$(md5sum "${APPL}-${VERSION}-${ARCH}-${BUILD}${AUTHOR}.txz" | \
	cut -d ' ' -f 1)
popd

cat > "${TMP}/${APPL}-${VERSION}-${ARCH}-${BUILD}${AUTHOR}.pkgdesc"<<HERE
APPL ${APPL}
VERSION ${VERSION}
CHECKSUM MD5#${MD5SUM}
HERE
# EOF
