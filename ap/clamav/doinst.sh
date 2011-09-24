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

/usr/sbin/groupadd -r clamav
/usr/sbin/useradd -r -g clamav -s /no/shell -d /no/where clamav

config etc/clamav/clamd.conf.new
config etc/clamav/freshclam.conf.new
touch /var/log/clamd.log
touch /var/log/freshclam.log
chown clamav:root /var/log/clamd.log
chown clamav:root /var/log/freshclam.log
mkdir /var/run/clamav
chown clamav:clamav /var/run/clamav
mkdir /var/lib/clamav
chown clamav:clamav /var/lib/clamav/

