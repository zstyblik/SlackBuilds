#!/bin/bash
set -e
set -u
PKGNAME=${PKGNAME:-'postfix'}
VERSION=${VERSION:-'2.9.7'}

if [ -z ${DISTPKG} ] || [ -z ${SBDIR} ]; then
	exit 254
fi

if [ ! -e "${SOURCES}/postfix-${VERSION}.tar.gz" ]; then
	wget --no-check-certificate \
		"http://de.postfix.org/ftpmirror/official/postfix-${VERSION}.tar.gz"\
		-O "${SOURCES}/postfix-${VERSION}.tar.gz"
fi

#MAKEPOS=`( grep -e make -m 1 -n ${DISTPKG}/${PKGNAME}.SlackBuild || echo 0: ) | cut -d: -f1`
#let MAKEPOS=$MAKEPOS-1
#if [ $MAKEPOS -lt 1 ]; then
#	echo 'make not found'
#	exit 2;
#fi

# back-up original dist SBo
#if [ ! -e ${DISTPKG}/${PKGNAME}.SlackBuild.dist ]; then
#	cp ${DISTPKG}/${PKGNAME}.SlackBuild{,.dist};
#else
#	cp ${DISTPKG}/${PKGNAME}.SlackBuild{.dist,};
#fi

## EXAMPLE No.1
#sed "/configure/,${MAKEPOS}c . ${SBDIR}/${PKGNAME}-configure " \
#${DISTPKG}/${PKGNAME}.SlackBuild.dist > ${DISTPKG}/${PKGNAME}.SlackBuild

## EXAMPLE No.2
#sed "/VERSION=/,1c VERSION=${VERSION} " \
#${DISTPKG}/${PKGNAME}.SlackBuild.dist > ${DISTPKG}/${PKGNAME}.SlackBuild

#cd ${DISTPKG}
./${PKGNAME}.SlackBuild || exit $?

#removepkg /var/log/packages/${PKGNAME}*
#installpkg /tmp/${PKGNAME}-${VERSION}*.txz

# EOF
