#!/bin/sh
#broth.sh - the base of all soups

BUILDER=`whoami`
BUILD_DIRECTORY="/home/$BUILDER/puredyne-build"
BROTH_DIRECTORY=`pwd`
PUREDYNE_VERSION="pure:dyne carrot&coriander"
PUREDYNE_PACKAGES="puredyne-CD"
KERNEL_PACKAGES="linux-image-2.6.24.7-rt21-pure linux-headers-2.6.24.7-rt21-pure linux-uvc-modules-2.6.24.7-rt21-pure alsa-modules-2.6.24.7-rt21-pure atl2-modules-2.6.24.7-rt21-pure"

# live builder specific settings
serverconf() {
    if [ `cat /etc/hostname` == "livebuilder.goto10.org" ]; then
        echo "livebuilder mode"
        BUILD_MIRRORS="--mirror-bootstrap \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
        --mirror-chroot \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
        --mirror-chroot-security \"http://10.80.80.20:3142/security.debian.org/\""
    else
        echo "localhost mode"
        BUILD_MIRRORS="--mirror-bootstrap \"http://mirror.ox.ac.uk/debian/\" \
        --mirror-chroot \"http://mirror.ox.ac.uk/debian/\" \
        --mirror-chroot-security \"http://security.debian.org/\""
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
    --language "en" \
    --linux-flavours "686" \
    --packages-lists $PUREDYNE_PACKAGES \
    --architecture "i386" \
    --distribution "lenny" \
    --apt "aptitude" \
    --apt-recommends "disabled" \
    --apt-secure "disabled" \
    --verbose
#    --aptitude-options "--assume-yes"
#    --apt-options "--yes --force-yes"
}

stock() {
    sudo cp -r $BROTH_DIRECTORY/stock/* $BUILD_DIRECTORY/config/
}

broken_config() {
    echo "_DEBUG=\"enabled\"" >> $BUILD_DIRECTORY/config/common
    echo "APT_OPTIONS=\"--yes --force-yes\"" >> $BUILD_DIRECTORY/config/common
    echo "APTITUDE_OPTIONS=\"--assume-yes\"" >> $BUILD_DIRECTORY/config/common 
    echo "LH_CATEGORIES=\"main contrib non-free\"" >> $BUILD_DIRECTORY/config/bootstrap
    echo "LH_KEYRING_PACKAGES=\"debian-archive-keyring debian-multimedia-keyring debian-puredyne-keyring\"" >> $BUILD_DIRECTORY/config/chroot
}

if [ ! -d $BUILD_DIRECTORY ]; then
    mkdir -p $BUILD_DIRECTORY
    cd $BUILD_DIRECTORY
    serverconf
    brothconfig
    stock
    broken_config
    sudo lh_build | tee broth.log
else
    cd $BUILD_DIRECTORY
    serverconf
    sudo lh clean
    brothconfig
    stock
    broken_config
    sudo lh_build | tee broth.log
fi

