#!/bin/bash

# Removing the Audio category ensures mplayer stays in the Multimedia category
echo "7c7
< Categories=GNOME;Application;AudioVideo;
---
> Categories=GNOME;Application;AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/nted.desktop

