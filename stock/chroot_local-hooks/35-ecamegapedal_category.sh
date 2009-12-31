#!/bin/bash

echo "9c9
< Categories=AudioVideo;
---
> Categories=AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/ecamegapedal.desktop

