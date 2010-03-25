#!/bin/bash

if [ -e "/usr/share/applications/cinelerra.desktop" ]
then

echo "10c10
< Exec=Cinelerra
---
> Exec=cinelerra" | patch --no-backup-if-mismatch --forward /usr/share/applications/cinelerra.desktop

fi

