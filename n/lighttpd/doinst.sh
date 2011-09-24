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

useradd -r -d /var/lib/lighttpd/ -c 'lighttpd user' -s /no/where -U lighttpd \
	|| true
mkdir /var/log/lighttpd || true
chown lighttpd:root /var/log/lighttpd
chmod o-rwx /var/log/lighttpd
mkdir /var/www || true
mkdir /var/www/htdocs || true
chown lighttpd:lighttpd /var/www
chown lighttpd:lighttpd /var/www/htdocs
ln -s /var/www /srv/lighttpd || true
