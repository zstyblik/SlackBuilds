#!/bin/bash
set -e
set -u
/usr/sbin/groupadd -r amavisd || true
/usr/sbin/useradd -r -g amavisd -d /var/amavis -s /bin/bash amavisd || true
./clamav.SlackBuild || exit $?
/usr/sbin/userdel amavisd || true
/usr/sbin/groupdel amavisd || true
