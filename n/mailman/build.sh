#!/bin/bash
set -e
set -u

/usr/sbin/groupadd -r mailman || true
/usr/sbin/useradd -r -g mailman -d /no/home -c 'GNU Mailman' \
-s /no/shell mailman  || true
./mailman.SlackBuild || exit $?
/usr/sbin/userdel mailman || true
/usr/sbin/groupdel mailman || true
