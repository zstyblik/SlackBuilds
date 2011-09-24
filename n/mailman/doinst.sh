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

config var/lib/mailman/data/sitelist.cfg.new
config var/lib/mailman/Mailman/mm_cfg.py.new
config var/lib/mailman/Mailman/mm_cfg.py.dist.new

/usr/sbin/groupadd -r mailman || true
/usr/sbin/useradd -r -g mailman -d /no/home -c 'GNU Mailman' \
-s /no/shell mailman
/var/lib/mailman/bin/check_perms -f

