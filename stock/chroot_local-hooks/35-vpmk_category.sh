#!/bin/bash

# This patch is based on http://vmpk.cvs.sourceforge.net/viewvc/vmpk/vmpk/vmpk.desktop?r1=1.3&r2=1.4&view=patch
echo "7c7
< Categories=AudioVideo;Midi
---
> Categories=AudioVideo;Audio;Midi;Education;Music;" | patch --no-backup-if-mismatch --forward /usr/share/applications/vmpk.desktop

