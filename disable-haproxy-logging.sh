#bin/bash

# Hard Disable Octavia Amphora HAProxy logging as qcow2 image preset

source .env-build

image=image/octavia-amphora-haproxy-$DISTR-$VERSION.qcow2
apt install -y libguestfs-tools

guestfish -a $image -i << EOF
write /etc/rsyslog.d/30-disable-haproxy-logging.conf ':programname, startswith, "haproxy" stop'
ls /etc/rsyslog.d/
cat /etc/rsyslog.d/30-disable-haproxy-logging.conf
EOF
