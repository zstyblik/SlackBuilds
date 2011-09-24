#!/bin/bash
set -e
set -u

PKGNAME=lzo
PKGVER='2.03'

if [ -z $DISTPKG ] || [ -z $SBDIR ]; then
	exit 254
fi

# back-up original dist SBo
if [ ! -e ${DISTPKG}/${PKGNAME}.SlackBuild.dist ]; then
	cp ${DISTPKG}/${PKGNAME}.SlackBuild{,.dist};
else 
	cp ${DISTPKG}/${PKGNAME}.SlackBuild{.dist,};
fi

sed "/VERSION=/,1c VERSION=${PKGVER} " \
${DISTPKG}/${PKGNAME}.SlackBuild.dist > ${DISTPKG}/${PKGNAME}.SlackBuild

cp ./lzo-${PKGVER}.tar.gz ${DISTPKG}/ || \
{ echo "path '${DISTPKG}'"; exit 200; }

cd ${DISTPKG}
./${PKGNAME}.SlackBuild || \
{ echo "SlackBuild failed."; exit $?; }

removepkg /var/log/packages/${PKGNAME}*
installpkg /tmp/${PKGNAME}-*.txz

