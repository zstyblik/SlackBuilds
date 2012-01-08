#!/bin/bash
set -e
set -u

VERSION=${VERSION:-'v3.6c'}
ARCH=${ARCH:-$(uname -m)}
NUMJOBS=${NUMJOBS:-" -j7 "}
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

cd "${TMP}"

rm -Rf "${VAR_INSTALL_MOD_PATH}"
rm -Rf "${TMP}/${APPL}-${VERSION}"

tar vjxf "${CWD}/${APPL}-${VERSION}.tar.bz2"
cd "${APPL}-${VERSION}"
make clean || exit 1
make INSTALL_MOD_PATH=${VAR_INSTALL_MOD_PATH} LINUX_SOURCE=${VAR_LINUX_SOURCE} \
	|| exit 2

cd "${VAR_INSTALL_MOD_PATH}"
find "${VAR_INSTALL_MOD_PATH}" -name modules.* -exec rm {} \;
mkdir "${VAR_INSTALL_MOD_PATH}/install" 2>/dev/null

cat "${CWD}/slack-desc" > "${VAR_INSTALL_MOD_PATH}/install/slack-desc" || \
echo "slack-desc not found."

cat "${CWD}/doinst.sh" > "${VAR_INSTALL_MOD_PATH}/install/doinst.sh" || \
echo "doinst.sh not found."

makepkg -l y -c n "${TMP}/${APPL}-${VERSION}-${KVERSION}${KERNNAME}-${ARCH}-${BUILD}.txz"

md5sum "${TMP}/${APPL}-${VERSION}-${KVERSION}${KERNNAME}-${ARCH}-${BUILD}.txz" \
	> "${TMP}/${APPL}-${VERSION}-${KVERSION}${KERNNAME}-${ARCH}-${BUILD}.md5"
