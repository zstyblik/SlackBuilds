#!/bin/bash
set -e
set -u
set -x
PKGNAME="gd"
CWD=$(pwd)

if [ -z "${DISTPKG}" ] || [ -z "${SBDIR}" ]; then
	exit 254
fi

MAKEPOS=$( ( grep -e make -m 1 -n "${DISTPKG}/${PKGNAME}.SlackBuild" || printf "0:" ) | cut -d ':' -f 1)
MAKEPOS=$(($MAKEPOS - 1))
if [ ${MAKEPOS} -lt 1 ]; then
	echo "${MAKEPOS}"
	echo 'make not found'
	exit 2;
fi

cp ${DISTPKG}/* ./
# back-up original dist SBo
if [ ! -e "${CWD}/${PKGNAME}.SlackBuild.dist" ]; then
	cp ${DISTPKG}/${PKGNAME}.SlackBuild ${CWD}/${PKGNAME}.SlackBuild.dist
else
	cp "${CWD}/${PKGNAME}.SlackBuild.dist" "${CWD}/${PKGNAME}.SlackBuild"
fi

## EXAMPLE No.1
sed -e "/configure/,${MAKEPOS}c . ${SBDIR}/${PKGNAME}-configure " \
	${DISTPKG}/${PKGNAME}.SlackBuild > ./${PKGNAME}.SlackBuild

#cd ${DISTPKG}
chmod u+x ${PKGNAME}.SlackBuild
./${PKGNAME}.SlackBuild || exit $?

removepkg /var/log/packages/${PKGNAME}*
installpkg /tmp/${PKGNAME}-*.txz

