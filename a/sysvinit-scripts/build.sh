#!/bin/bash
set -e
set -u

PKGNAME='sysvinit-scripts'
# somewhat randomly chosen off-set, so we don't have to keep up with official
# numbers
BUILD=1043 
export BUILD

./${PKGNAME}.SlackBuild || { echo "SlackBuild has failed."; exit $?; }

unset BUILD
