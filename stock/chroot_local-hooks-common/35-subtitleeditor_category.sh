#!/bin/bash

if [ -e "/usr/share/applications/subtitleeditor.desktop" ]
then

echo "9c9
< Categories=Audio;AudioVideo;AudioVideoEditing;
---
> Categories=Video;AudioVideo;AudioVideoEditing;" | patch --no-backup-if-mismatch --forward /usr/share/applications/subtitleeditor.desktop

fi
