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

if [ ! -d /var/cache/logwatch/ ]; then
	mkdir -p /var/cache/logwatch
	chmod 750 /var/cache/logwatch
fi
ln -s /usr/share/logwatch/scripts/logwatch.pl /etc/cron.daily/0logwatch
ln -s /usr/share/logwatch/scripts/logwatch.pl /usr/sbin/logwatch

config /etc/logwatch/conf/logwatch.conf.new
config /etc/logwatch/conf/ignore.conf.new
config /etc/logwatch/conf/override.conf.new

if [ ! -s /etc/logwatch/conf/logwatch.conf ]; then
	cp /usr/share/logwatch/default.conf/logwatch.conf \
		/etc/logwatch/conf/logwatch.conf
fi
if [ ! -s /etc/logwatch/conf/ignore.conf ]; then
	cp /usr/share/logwatch/default.conf/ignore.conf \
		/etc/logwatch/conf/ignore.conf
fi
# EOF
