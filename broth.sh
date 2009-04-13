#!/bin/sh
#broth.sh - the base of all soups

if [ -d .svn ]; then
    echo "don't run me from SVN! export me somewhere else"
    exit
fi



echo "broth - the mother of all soups"

lh config \
    --mirror-bootstrap "" \
    --mirror-chroot "" \
    --binary-indices disabled

