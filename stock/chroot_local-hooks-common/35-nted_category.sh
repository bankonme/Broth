#!/bin/bash
# Removing the Audio category ensures nted stays in the Multimedia category

if [ -e "/usr/share/applications/nted.desktop" ]
then
    echo "7c7
< Categories=GNOME;Application;AudioVideo;
---
> Categories=GNOME;Application;AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/nted.desktop
fi
