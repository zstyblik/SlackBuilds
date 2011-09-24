#!/bin/bash
set -e
set -u
PKGNAME=netcat-openbsd
PKGVER=0

./${PKGNAME}.SlackBuild || { echo "SlackBuild has failed."; exit $?; }

