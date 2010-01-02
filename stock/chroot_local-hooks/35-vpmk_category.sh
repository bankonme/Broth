#!/bin/bash

# This patch is based on http://vmpk.cvs.sourceforge.net/viewvc/vmpk/vmpk/vmpk.desktop?r1=1.3&r2=1.4&view=patch
# ARGH except with the "Education" cat removed since that makes an extra menu
echo "7c7
< Categories=AudioVideo;Midi
---
> Categories=AudioVideo;Audio;Midi;Music;" | patch --no-backup-if-mismatch --forward /usr/share/applications/vmpk.desktop

