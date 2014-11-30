#!/bin/bash
set -e
set -u
PKGNAME=util-linux
PKGVER=2.21.2
unset SOURCES

if [ ! -d "./${SLACKVER}" ]; then
	printf "%s sources not found in './%s'.\n" $PKGNAME $SLACKVER
	exit 1
fi # if [ ! -d "./${SLACKVER}" ]

./${PKGNAME}.SlackBuild || exit $?

