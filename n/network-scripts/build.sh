#!/bin/bash
PKGNAME=network-scripts
set -e
set -u
# ToDo
if [ ! -e ./scripts/rc.inet2.dist ]; then
	cp ./scripts/rc.inet2 ./scripts/rc.inet2.dist;
fi
cp ./scripts/rc.inet2.dist ./scripts/rc.inet2

cat >> "./scripts/rc.inet2" <<EOF
if [ -x /etc/rc.d/rc.openldap-server ]; then
	/etc/rc.d/rc.openldap-server start
fi

if [ -x /usr/sbin/quagga.init ]; then
	/usr/sbin/quagga.init start
fi

if [ -x /etc/rc.d/rc.dhcpd ]; then
	/etc/rc.d/rc.dhcpd start
fi

if [ -x /etc/rc.d/rc.firewall-local ]; then
	/etc/rc.d/rc.firewall-local start || \\
	/etc/rc.d/rc.firewall-local stop
fi

if [ -x /etc/rc.d/rc.firewall-lan ]; then
	/etc/rc.d/rc.firewall-lan start || \\
	/etc/rc.d/rc.firewall-lan stop
fi

if [ -x /etc/rc.d/rc.firewall-blocked ]; then
	/etc/rc.d/rc.firewall-blocked start || \\
	/etc/rc.d/rc.firewall-blocked stop
fi
EOF

./${PKGNAME}.SlackBuild || { echo "SlackBuild has failed."; exit $?; }

removepkg /var/log/packages/${PKGNAME}*
installpkg /tmp/${PKGNAME}-*.txz
