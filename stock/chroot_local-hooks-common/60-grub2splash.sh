#!/bin/bash

if [ -e "/etc/grub.d/05_debian_theme" ]
then
    echo "10c10
<   WALLPAPER=\"/usr/share/images/desktop-base/moreblue-orbit-grub.png\"
---
>   WALLPAPER=\"/usr/share/images/desktop-base/grubsplash-puredyne-logo-simple.png\"
" | patch --no-backup-if-mismatch --forward /etc/grub.d/05_debian_theme
fi
#
