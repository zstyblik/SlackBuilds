#!/bin/bash
set -e
set -u
PKGNAME=tfn-firewall
PKGVER=0

./${PKGNAME}.SlackBuild || { echo "SlackBuild has failed."; exit $?; }
