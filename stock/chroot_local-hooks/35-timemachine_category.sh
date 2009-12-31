#!/bin/bash

echo "7c7
< Categories=AudioVideo;
---
> Categories=AudioVideo;Audio;" | patch --no-backup-if-mismatch --forward /usr/share/applications/timemachine.desktop

