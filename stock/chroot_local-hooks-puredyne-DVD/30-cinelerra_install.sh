#!/bin/bash
## broth/stock/chroot_local-hooks/30-cinelerra_install.sh
## Shitty hack to trick dpkg to install cinelerra from the akirad repos in the chroot.
#
## dependencies
#aptitude --assume-yes install optlibx11-noxcb-data optlibx11-noxcb-6 libguicastcv libmpeg3cv libquicktimecv akiradnews
#
#apt-get install --assume-yes --download-only cinelerracv
#dpkg --unpack /var/cache/apt/archives/cinelerracv*
#
## yes, we remove it even if not triggered otherwise it will be a problem as soon as
## aptitude or dpkg -a (etc..) are called while still in the chroot.
#grep -Ev shmmax /var/lib/dpkg/info/cinelerracv.postinst > tmpcine
#mv tmpcine /var/lib/dpkg/info/cinelerracv.postinst

