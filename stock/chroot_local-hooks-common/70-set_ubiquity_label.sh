#!/bin/sh

# Replace the "RELEASE" keyword in the ubiquity menu item so it says "Install puredyne"
TMPFILE="ubiquity-gtkui.desktop.tmp"
TARGETFILE="/usr/share/applications/ubiquity-gtkui.desktop"
sed 's|RELEASE|puredyne|g' "$TARGETFILE" > "$TMPFILE" \
 && mv -f "$TMPFILE" "$TARGETFILE"
