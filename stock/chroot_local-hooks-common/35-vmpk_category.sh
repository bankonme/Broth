#!/bin/bash
# Remove vmpk from 'Education' cat; not needed, and looks silly on its own in vanilla puredyne

if [ -e "/usr/share/applications/vmpk.desktop" ]
then
    echo "7c7
< Categories=AudioVideo;Audio;Midi;Education;Music;
---
> Categories=AudioVideo;Audio;Midi;Music;" | patch --no-backup-if-mismatch --forward /usr/share/applications/vmpk.desktop
fi
