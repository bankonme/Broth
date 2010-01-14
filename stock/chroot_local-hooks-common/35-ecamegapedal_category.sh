#!/bin/bash

if [ -e "/usr/share/applications/ecamegapedal.desktop" ]
then
    echo "9c9
< Categories=AudioVideo;
---
> Categories=AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/ecamegapedal.desktop
fi
