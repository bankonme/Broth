#/bin/sh

# Replace the "RELEASE" keyword in the ubiquity menu item so it says "Install puredyne"
sed s/RELEASE/puredyne/g /usr/share/applications/ubiquity-gtkui.desktop > ubiquity-gtkui.desktop.tmp && mv -f ubiquity-gtkui.desktop.tmp /usr/share/applications/ubiquity-gtkui.desktop

