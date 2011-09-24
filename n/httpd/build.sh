#!/bin/bash
set -e
set -u
PKGNAME=httpd
PKGVER=2.2.19

if [ -z "${DISTPKG}" ] || [ -z "${SBDIR}" ]; then
	exit 254
fi

MAKEPOS=$((grep -e 'make' -m 1 -n "/mnt/cdrom/source/n/httpd/${PKGNAME}.SlackBuild" || echo 0: ) | \
	cut -d ':' -f 1)
MAKEPOS=$(($MAKEPOS-1))
if [ $MAKEPOS -lt 1 ]; then
	echo 'make not found'
	exit 2;
fi

# back-up original dist SBo
if [ ! -e "${DISTPKG}/${PKGNAME}.SlackBuild.dist" ]; then
	cp "/mnt/cdrom/source/n/httpd/${PKGNAME}.SlackBuild" \
		"${PKGNAME}.SlackBuild.dist"
fi

sed "/VERSION=/,1c VERSION=${PKGVER} " \
"${PKGNAME}.SlackBuild.dist" > "${PKGNAME}.SlackBuild"

#echo `pwd`
#cp "${PKGNAME}-${PKGVER}.tar.bz2" ${DISTPKG}/ || \
#{ echo "path '${DISTPKG}'"; exit 200; }

#cd ${DISTPKG}
./${PKGNAME}.SlackBuild || \
{ echo "SlackBuild failed."; exit $?; }

removepkg /var/log/packages/${PKGNAME}*
installpkg /tmp/${PKGNAME}-*.txz

