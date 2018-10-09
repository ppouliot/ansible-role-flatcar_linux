#!/usr/bin/env bash
LOGFILE='/home/core/upgrade_flatcar.log'

exec >> $LOGFILE 2>&1

echo "Setting passwordless sudo for core user"
sed -i "/core/c\core\ ALL\=\(ALL\)\ NOPASSWD\:\ ALL" /etc/sudoers.d/waagent


echo "Get the Flatcar Linux Public Update Key."
curl -L -o /tmp/key https://raw.githubusercontent.com/flatcar-linux/coreos-overlay/flatcar-master/coreos-base/coreos-au-key/files/official-v2.pub.pem

echo "Mountingthe Flatcar Linux Public Update Key to /usr/share/update_engine/udate-payload-key.pub.pem."
mount --bind /tmp/key /usr/share/update_engine/update-payload-key.pub.pem

echo "Setting the Flatcar Linux update url in /etc/coreos/update.conf"
echo "SERVER=https://public.update.flatcar-linux.net/v1/update/" >> /etc/coreos/update.conf

echo "Clearing the current version number from the release file"
cp /usr/share/coreos/release /tmp
sed -i "/COREOS_RELEASE_VERSION/c\COREOS_RELEASE_VERSION\=0.0.0" /tmp/release
mount --bind /tmp/release /usr/share/coreos/release

echo "Restarting the CoreOS Update engine."
systemctl restart update-engine

echo "Triggering  manual update"
update_engine_client -update
