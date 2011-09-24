config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

groupadd -r postdrop
groupadd -r postfix
useradd -r -g postfix -d /no/where -s /no/shell postfix

for FILE in $(echo "/usr/sbin/sendmail /usr/bin/mailq /usr/bin/newaliases"); do
	if [ -e "${FILE}" ]; then
		cp "${FILE}" "${FILE}.OFF"
		chmod 755 "${FILE}.OFF"
		rm -f "${FILE}"
	fi
done

config etc/postfix/access.new
config etc/postfix/aliases.new
config etc/postfix/bounce.cf.default.new
config etc/postfix/canonical.new
config etc/postfix/generic.new
config etc/postfix/header_checks.new
config etc/postfix/main.cf.new
config etc/postfix/main.cf.default.new
config etc/postfix/makedefs.out.new
config etc/postfix/master.cf.new
config etc/postfix/relocated.new
config etc/postfix/transport.new
config etc/postfix/virtual.new

/usr/sbin/postfix set-permissions setgid_group=postdrop mail_owner=postfix

mv /usr/sbin/sendmail.postfix /usr/sbin/sendmail
ln -s /usr/sbin/sendmail /usr/bin/mailq
ln -s /usr/sbin/sendmail /usr/bin/newaliases
ln -s /usr/sbin/sendmail /usr/bin/sendmail
