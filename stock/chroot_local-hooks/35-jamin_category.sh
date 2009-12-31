#!/bin/bash

echo "8c8
< Categories=Application;AudioVideo;
---
> Categories=Application;AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/jamin.desktop
