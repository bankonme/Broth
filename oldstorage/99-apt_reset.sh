#!/bin/sh
# During the chroot, we use a local apt cache, once the
# chroot is finished we need to restore the sources so that
# the live system points to the right deb repos.

echo "Restoring apt sources"

sed -i 's/10.80.80.20:3142\///g' /etc/apt/sources.list

