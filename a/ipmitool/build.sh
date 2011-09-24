#!/bin/bash
set -e
set -u
PKGNAME=ipmitool
PKGVER=0

./${PKGNAME}.SlackBuild || { echo "SlackBuild has failed."; exit $?; }

