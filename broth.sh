#!/bin/sh
#broth.sh - the base of all soups

BUILD_DIRECTORY="~/puredyne-build"


#if [ -d .svn ]; then
#    echo "don't run me from SVN! export me somewhere else"
#    exit
#fi

if [ ! -d $BUILD_DIRECTORY ]; then
    mkdir -p $BUILD_DIRECTORY
else
    cd $BUILD_DIRECTORY
    lh clean
fi



cd $BUILD_DIRECTORY

lh config \
    --mirror-bootstrap "" \
    --mirror-chroot "" \
    --binary-indices disabled

