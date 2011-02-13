#!/bin/bash
# emacs23 'Development' category is not evil, but looks silly in vanilla pd on its own, and not neccessary since in other menus

if [ -e "/usr/share/applications/emacs23.desktop" ]
then
    echo "13c13
< Categories=Utility;Development;TextEditor;
---
> Categories=Utility;TextEditor;" | patch --no-backup-if-mismatch --forward /usr/share/applications/emacs23.desktop
fi
