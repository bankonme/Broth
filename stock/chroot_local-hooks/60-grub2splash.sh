#!/bin/bash

if [ -e "/etc/grub.d/05_debian_theme" ]
then
    echo "16c16
<   for i in {/boot/grub,/usr/share/images/desktop-base}/moreblue-orbit-grub.{png,tga} ; do
---
>   for i in {/boot/grub,/usr/share/images/desktop-base}/grubsplash-puredyne-logo-simple.{png,tga} ; do
39,40c39,40
<   set color_normal=black/black
<   set color_highlight=magenta/black
---
>   set color_normal=white/black
>   set color_highlight=green/black" | patch --no-backup-if-mismatch --forward /etc/grub.d/05_debian_theme
fi

