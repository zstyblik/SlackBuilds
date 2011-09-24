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

config etc/libvirt/libvirtd.conf.new
config etc/libvirt/lxc.conf.new
config etc/libvirt/qemu.conf.new
#config etc/logrotate.d/libvirtd.lxc.new
config etc/logrotate.d/libvirtd.qemu.new
config etc/logrotate.d/libvirtd.uml.new
config etc/sasl2/libvirt.conf.new

