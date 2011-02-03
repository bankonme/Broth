#!/bin/bash

if [ -e "/usr/share/ubiquity/install.py" ]
then
    echo "56,57c56
<         self.casper_path = os.path.join(
<             '/cdrom', get_casper('LIVE_MEDIA_PATH', 'casper').lstrip('/'))
---
>         self.casper_path = '/live/image/live'; #puredyne-specific path" | patch --no-backup-if-mismatch --forward /usr/share/ubiquity/install.py
fi

