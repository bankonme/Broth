#!/bin/bash -e
# broth.sh - the base of all soups
# Note: bash -e == exits on errors

# global variables
BUILDER=`whoami`
BROTH_DIRECTORY=`pwd`
#PUREDYNE_LINUX="linux-image-2.6.29.3-rt14-pure linux-headers-2.6.29.3-rt14-pure"
PUREDYNE_LINUX="linux-image"
PUREDYNE_ARCH="i386"

# live builder specific settings
serverconf() {
    if [ `cat /etc/hostname` == "builder" ]; then
        echo "bob the builder mode"
        PUREDYNE_VERSION="pure:dyne carrot&coriander"
        BUILD_DIRECTORY="/goto/puredyne-build-$PUREDYNE_ARCH"
        BUILD_MIRRORS="--mirror-bootstrap \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot-security \"http://security.ubuntu.com/ubuntu\""
#        BUILD_MIRRORS="--mirror-bootstrap \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
#        --mirror-chroot \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
#        --mirror-chroot-security \"http://10.80.80.20:3142/security.debian.org/\""
    else
        echo "remix/test mode"
        PUREDYNE_VERSION="pure:dyne remix"
        BUILD_DIRECTORY="/home/$BUILDER/puredyne-build-$PUREDYNE_ARCH"
        BUILD_MIRRORS="--mirror-bootstrap \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot-security \"http://security.ubuntu.com/ubuntu\""
    fi
}

brothconfig() {
lh_config \
    $BUILD_MIRRORS \
    --mirror-binary "http://uk.archive.ubuntu.com/ubuntu" \
    --mirror-binary-security "http://security.ubuntu.com/ubuntu" \
    --binary-indices disabled \
    --bootappend-live "persistent" \
    --hostname "puredyne" \
    --iso-application "pure:dyne" \
    --iso-preparer "live-helper $VERSION" \
    --iso-publisher "pure:dyne team; http://puredyne.goto10.org; puredyne-team@goto10.org" \
    --iso-volume $PUREDYNE_VERSION \
    --syslinux-splash "config/binary_syslinux/splash.rle" \
    --syslinux-timeout "10" \
    --syslinux-menu "enabled" \
    --username "lintian" \
    --language "en" \
    --linux-packages $PUREDYNE_LINUX \
    --linux-flavours "generic" \
    --packages-lists $PACKAGES_LISTS \
    --categories "main restricted universe multiverse" \
    --architecture $PUREDYNE_ARCH \
    --mode "ubuntu" \
    --distribution "karmic" \
    --initramfs "live-initramfs" \
    --apt "aptitude" \
    --apt-recommends "disabled" \
    --apt-secure "disabled"
}

stock() {
    cp -r $BROTH_DIRECTORY/stock/* $BUILD_DIRECTORY/config/
    chmod -R o+rw $BUILD_DIRECTORY/config/
}

broken_config() {
# The following arguments are not accepted by lh_config ATM
    echo "_DEBUG=\"enabled\"" >> $BUILD_DIRECTORY/config/common
    echo "APT_OPTIONS=\"--yes --force-yes\"" >> $BUILD_DIRECTORY/config/common
    echo "APTITUDE_OPTIONS=\"--assume-yes\"" >> $BUILD_DIRECTORY/config/common 
}

make_soup() {
    serverconf
    if [ ! -d $BUILD_DIRECTORY ]; then
        mkdir -p $BUILD_DIRECTORY
	cd $BUILD_DIRECTORY
    else
        cd $BUILD_DIRECTORY
        sudo lh clean
        rm -rf $BUILD_DIRECTORY/config
    fi
    brothconfig
    stock
    broken_config
    sudo lh build | tee broth.log
}

usage()
{
cat << EOF
BROTH - The mother of all soups
usage: $0 options
   -h      Show this message
   -o      Choose output (CD or DVD or CUSTOM)
   -a      Choose target architecture (EXPERIMENTAL!)
EOF
}

if [ "$1" == "" ]; then
    usage ; exit 1
else
    while getopts "ho:a:" OPTION ; do
	case $OPTION in
	    h)  usage ; exit 1;;
            o)  OPTARG=`echo $OPTARG | tr '[:lower:]' '[:upper:]'`
		if [ $OPTARG == "CD" -o $OPTARG == "DVD" -o $OPTARG == "CUSTOM" ]; then
                    PACKAGES_LISTS="puredyne-$OPTARG"
		    echo "starting building of $PACKAGES_LISTS"
		    #make_soup
		else
                    echo "profile unknown, kthxbye"; exit -1
		fi
		;;
            a)  if [ $OPTARG == "i386" -o $OPTARG == "amd64" -o $OPTARG == "ppc" ]; then
                    PUREDYNE_ARCH=$OPTARG
                    echo "building puredyne for $OPTARG"
                else
                    echo "architecture unknown, kthxbye"; exit -1
                fi
                ;;
	    *) echo "Not recognized argument, kthxbye"; exit -1 ;;
	esac
    done
fi

make_soup

