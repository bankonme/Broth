#!/bin/sh
# place an installer icon on lintian's desktop
echo "

[ Desktop Entry]
Version=1.0
Encoding=UTF-8
Type=Application
Name=install Puredyne
Comment=Install puredyne to your harddrive
Categories=Application;
Exec=sudo ubiquity
Icon=puredyne-icon
Terminal=false
StartupNotify=false

"  > /home/lintian/Installer.desktop