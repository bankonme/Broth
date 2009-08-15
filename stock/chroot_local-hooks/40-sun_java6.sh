#!/bin/sh

# This is a hook for live-helper(7) to install sun-java and jav related software.
# To enable it, copy this hook into your config/chroot_local-hooks directory.

# live-helper sets DEBIAN_FRONTEND to 'noninteractive' to advise debconf to not
# ask any questions while installing packages. Suns redistribution terms for
# Java do not allow this, therefore we need to overwrite DEBIAN_FRONTEND for
# this apt-get call only.

echo "sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true" > /root/preseed
debconf-set-selections < /root/preseed
rm -f /root/preseed

DEBIAN_FRONTEND="dialog" apt-get install --yes sun-java6-bin \
	sun-java6-fonts sun-java6-jre sun-java6-plugin \
	processing arduino
