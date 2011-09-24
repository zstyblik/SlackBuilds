#!/bin/bash
set -e
set -u
PKGNAME=util-linux
PKGVER=2.19.1

if [ -z $DISTPKG ] || [ -z $SBDIR ]; then
	exit 254
fi

./${PKGNAME}.SlackBuild || exit $?

