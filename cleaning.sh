#!/bin/bash -eux

# Make sure Udev doesn't block our network
echo "Cleaning up udev rules"
rm -rf /dev/.udev/
# Better fix that persists package updates
touch /etc/udev/rules.d/75-persistent-net-generator.rules

echo "Cleaning up leftover dhcp leases"
if [ -d "/var/lib/dhcp" ]; then
    rm -f /var/lib/dhcp/*
fi

echo "Cleaning up tmp"
rm -rf /tmp/*

# Cleanup apt cache
echo "Cleaning up apt cache"
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

echo "Installed packages:"
dpkg --get-selections | grep -v deinstall

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Clean up log files
echo "Cleaning up log files"
find /var/log -type f -exec truncate --size 0 {} \;

echo "Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# Whiteout root
echo "Clearing root filesystem"
count=$(df --sync -kP / | tail -n1  | awk '{print $4}')
dd if=/dev/zero of=/zerofile bs=1M count=$count || echo "dd exit code $? is suppressed"
sync
rm -f /zerofile

# Whiteout /boot
echo "Clearing /boot"
count=$(df --sync -kP /boot | tail -n1 | awk '{print $4}')
dd if=/dev/zero of=/boot/zerofile bs=1M count=$count || echo "dd exit code $? is suppressed"
sync
rm -f /boot/zerofile

echo "Clearing swap and disabling until reboot"
set +e
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab
set -e

# Make sure we wait until all the data is written to disk
sync

echo "Disk usage before cleanup:"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "Disk usage after cleanup:"
df -h
