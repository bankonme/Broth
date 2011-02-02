#!/bin/sh
# temp fix to give the education section a proper icon in the menu

sed -i 's/Icon=/Icon=applications-science/g' /usr/share/desktop-directories/xfce-education.directory
