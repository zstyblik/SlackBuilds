mkdir /var/lib/postgres/
mkdir /var/lib/postgres/data
/usr/sbin/groupadd -r postgres || true
/usr/sbin/useradd -m -r -d /var/lib/postgres/home -g postgres postgres || true
chown postgres:postgres /var/lib/postgres
chown postgres:postgres /var/lib/postgres/data/
