#!/bin/bash

if [ -e "/usr/share/applications/timemachine.desktop" ]
then

echo "7c7
< Categories=AudioVideo;
---
> Categories=AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/timemachine.desktop

fi
