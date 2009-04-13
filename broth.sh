#!/bin/sh
#broth.sh - the base of all soups

BUILDER=`whoami`
BUILD_DIRECTORY="/home/$BUILDER/puredyne-build"


#if [ -d .svn ]; then
#    echo "don't run me from SVN! export me somewhere else"
#    exit
#fi

brothconfig() {
lh config \
    --mirror-bootstrap "" \
    --mirror-chroot "" \
    --binary-indices disabled
}



if [ ! -d $BUILD_DIRECTORY ]; then
    mkdir -p $BUILD_DIRECTORY
    brothconfig
else
    cd $BUILD_DIRECTORY
    lh clean
    brothconfig
fi

