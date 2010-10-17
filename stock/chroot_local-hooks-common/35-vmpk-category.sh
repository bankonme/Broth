#!/bin/bash

if [ -e "/usr/share/applications/vmpk.desktop" ]
then

# Remove the "Education" cat removed since that makes an extra menu, pah
echo "7c7
< Categories=AudioVideo;Audio;Midi;Education;Music
---
> Categories=AudioVideo;Audio;Midi;Music;" | patch --no-backup-if-mismatch --forward /usr/share/applications/vmpk.desktop

fi

