#!/bin/sh
#see https://wiki.ubuntu.com/KarmicKoala/ReleaseNotes#Upstart%20jobs%20cannot%20be%20run%20in%20a%20chroot
#
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl
