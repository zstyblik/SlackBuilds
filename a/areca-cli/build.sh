#!/bin/bash
set -e
set -u
PKGNAME=areca-cli
PKGVER=0

./${PKGNAME}.SlackBuild || { echo "SlackBuild has failed."; exit $?; }

