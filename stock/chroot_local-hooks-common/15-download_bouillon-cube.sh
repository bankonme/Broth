#!/bin/bash
# This hook will download the latest snapshot of some bouillon cube files
# This is needed until bouillon cube is mature enough to be packaged properly

bzr co lp:bouilloncube
mv bouilloncube/sh/grub2/make-live-device.sh /usr/sbin
mkdir -p /usr/share/bouilloncube/sh/grub2
mv bouilloncube/sh/grub2/grub.cfg.in /usr/share/bouilloncube/sh/grub2
rm -rf bouilloncube
