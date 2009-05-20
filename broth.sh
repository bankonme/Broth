#!/bin/bash
# broth.sh - the base of all soups

BUILDER=`whoami`
BUILD_DIRECTORY="/home/$BUILDER/puredyne-build"
BROTH_DIRECTORY=`pwd`
PUREDYNE_PACKAGES="puredyne-CD"
PUREDYNE_LINUX="linux-image-2.6.29.3-rt14-pure-686 linux-headers-2.6.29.3-rt14-pure-686"

# live builder specific settings
serverconf() {
    if [ `cat /etc/hostname` == "livebuilder.goto10.org" ]; then
        echo "livebuilder mode"
        PUREDYNE_VERSION="pure:dyne carrot&coriander"
        BUILD_MIRRORS="--mirror-bootstrap \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
        --mirror-chroot \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
        --mirror-chroot-security \"http://10.80.80.20:3142/security.debian.org/\""
    else
        echo "localhost mode"
        PUREDYNE_VERSION="pure:dyne remix"
        BUILD_MIRRORS="--mirror-bootstrap \"http://mirror.ox.ac.uk/debian/\" \
        --mirror-chroot \"http://mirror.ox.ac.uk/debian/\" \
        --mirror-chroot-security \"http://security.debian.org/\""
    fi
}

brothconfig() {
lh_config \
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
    --syslinux-splash "config/binary_syslinux/splash.rle" \
    --syslinux-timeout "10" \
    --syslinux-menu "enabled" \
    --username "lintian" \
    --language "en" \
    --linux-flavours "686" \
    --linux-packages $PUREDYNE_LINUX \
    --packages-lists $PUREDYNE_PACKAGES \
    --categories "main non-free contrib" \
    --keyring-packages "debian-archive-keyring debian-multimedia-keyring debian-puredyne-keyring" \
    --architecture "i386" \
    --distribution "lenny" \
    --apt "aptitude" \
    --apt-recommends "disabled" \
    --apt-secure "disabled"
}

stock() {
    sudo cp -r $BROTH_DIRECTORY/stock/* $BUILD_DIRECTORY/config/
}

broken_config() {
# The following arguments are not accepted by lh_config ATM
    echo "_DEBUG=\"enabled\"" >> $BUILD_DIRECTORY/config/common
    echo "APT_OPTIONS=\"--yes --force-yes\"" >> $BUILD_DIRECTORY/config/common
    echo "APTITUDE_OPTIONS=\"--assume-yes\"" >> $BUILD_DIRECTORY/config/common 
}

make_soup() {
    if [ ! -d $BUILD_DIRECTORY ]; then
        mkdir -p $BUILD_DIRECTORY
        cd $BUILD_DIRECTORY
        serverconf
    else
        cd $BUILD_DIRECTORY
        serverconf
        sudo lh clean
    fi
    brothconfig
    stock
    broken_config
    sudo lh_build | tee broth.log
}

make_soup

