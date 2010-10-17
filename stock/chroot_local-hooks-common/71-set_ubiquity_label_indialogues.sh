#!/bin/bash

if [ -e "/usr/lib/ubiquity/ubiquity/misc.py" ]
then
    echo "390c390
<             get_release.release_info = ReleaseInfo(name='Ubuntu', version='')
---
>             get_release.release_info = ReleaseInfo(name='Puredyne', version='')
418c418
<             get_release_name.release_name = 'Ubuntu'
---
>             get_release_name.release_name = 'Puredyne'" | patch --no-backup-if-mismatch --forward /usr/lib/ubiquity/ubiquity/misc.py
fi

