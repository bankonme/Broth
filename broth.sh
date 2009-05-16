#!/bin/sh
#broth.sh - the base of all soups

BUILDER=`whoami`
BUILD_DIRECTORY="/home/$BUILDER/puredyne-build"
BROTH_DIRECTORY=`pwd`
PUREDYNE_VERSION="pure:dyne carrot&coriander"
PUREDYNE_PACKAGES="puredyne-CD"
KERNEL_PACKAGES="linux-image-2.6.24.7-rt21-pure linux-headers-2.6.24.7-rt21-pure linux-uvc-modules-2.6.24.7-rt21-pure alsa-modules-2.6.24.7-rt21-pure atl2-modules-2.6.24.7-rt21-pure"

#if [ -d .svn ]; then
#    echo "don't run me from SVN! export me somewhere else"
#    exit
#fi

# live builder specific settings
serverconf() {
    if [ `cat /etc/hostname` == "livebuilder.goto10.org" ]; then
        echo "live"
        BUILD_MIRRORS="--mirror-bootstrap \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
        --mirror-chroot \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
        --mirror-chroot-security \"http://10.80.80.20:3142/security.debian.org/\""
    else
        echo "nonlive"
        BUILD_MIRRORS=""
    fi
}

brothconfig() {
_COLOR="enabled" lh config \
    $BUILD_MIRRORS \
    --mirror-binary "http://mirror.ox.ac.uk/debian/" \
    --mirror-binary-security "http://security.debian.org/" \
    --binary-indices disabled \
    --bootappend-live "persistent" \
    --debian-installer-distribution "lenny" \
    --hostname "puredyne" \
    --iso-application "pure:dyne team" \
    --iso-preparer "live-helper $VERSION" \
    --iso-publisher "pure:dyne team; http://puredyne.goto10.org; puredyne-team@goto10.org" \
    --iso-volume $PUREDYNE_VERSION \
    --syslinux-splash "binary_syslinux/splash.rle" \
    --syslinux-timeout "10" \
    --syslinux-menu "enabled" \
    --username "lintian" \
    --keyring-packages "debian-archive-keyring debian-multimedia-keyring debian-puredyne-keyring" \
    --language "en" \
    --linux-flavours "686" \
    --linux-packages $KERNEL_PACKAGES \
    --packages-lists $PUREDYNE_PACKAGES \
    --architecture "i386" \
    --distribution "lenny" \
    --categories "main contrib non-free" \
    --apt "aptitude" \
    --apt-recommends "disabled" \
    --apt-secure "disabled" \
    --verbose \
    --debug
#    --aptitude-options "--assume-yes"
#    --apt-options "--yes --force-yes"
}

stock() {
    sudo cp -r $BROTH_DIRECTORY/stock/* $BUILD_DIRECTORY/config/
}


if [ ! -d $BUILD_DIRECTORY ]; then
    mkdir -p $BUILD_DIRECTORY
    cd $BUILD_DIRECTORY
    serverconf
    brothconfig
    stock
    sudo lh_build
else
    cd $BUILD_DIRECTORY
    serverconf
    sudo lh clean
    brothconfig
    stock
    sudo lh_build
fi

