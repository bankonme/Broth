#!/bin/bash
# This script sets the pure:dyne version in a VERSION file
# located in /etc
# --
# TODO: make it fetch the values used by binary

DATE="/bin/date"

VERSION=$("${DATE}" +%Y%m%d)

echo "Setting VERSION file."
echo "${VERSION}" > /etc/VERSION
