#!/bin/sh
#broth.sh - the base of all soups

BUILDER=`whoami`
BUILD_DIRECTORY="/home/$BUILDER/puredyne-build"


#if [ -d .svn ]; then
#    echo "don't run me from SVN! export me somewhere else"
#    exit
#fi

# live builder specific settings
serverconf() {
    if [ `cat /etc/hostname` == "livebuilder.goto10.org" ]; then
        echo "live"
    else
        echo "nonlive"
    fi
}

brothconfig() {
lh config \
    --mirror-bootstrap "" \
    --mirror-chroot "" \
    --binary-indices disabled
}



if [ ! -d $BUILD_DIRECTORY ]; then
    mkdir -p $BUILD_DIRECTORY
    cd $BUILD_DIRECTORY
    serverconf
    brothconfig
else
    cd $BUILD_DIRECTORY
    serverconf
    lh clean
    brothconfig
fi

