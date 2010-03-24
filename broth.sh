#!/bin/bash -e
# broth.sh - the mother of all soups
#
# ---
#
# Notes: 
# * bash -e == exits on errors
#
# ---
#
#    Copyright (C) 2008-2010  Puredyne Team
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, version 3 of the license.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#


# global variables
BUILDER=`whoami`
BROTH_DIRECTORY=`pwd`
PUREDYNE_LINUX="linux"
#PUREDYNE_LINUX="linux-image"
PUREDYNE_ARCH="i386"
PARENTBUILD_DIRECTORY="/home/$BUILDER"
BUILD_DIRECTORY="$PARENTBUILD_DIRECTORY/puredyne-build-$PUREDYNE_ARCH"

# live builder specific settings
serverconf() {
    if [ `cat /etc/hostname` == "builder" ]; then
        echo "bob the builder mode"
        PUREDYNE_VERSION="Puredyne carrot&coriander"
        BUILD_MIRRORS="--mirror-bootstrap \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot-security \"http://security.ubuntu.com/ubuntu\""
#        BUILD_MIRRORS="--mirror-bootstrap \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
#        --mirror-chroot \"http://10.80.80.20:3142/mirror.ox.ac.uk/debian/\" \
#        --mirror-chroot-security \"http://10.80.80.20:3142/security.debian.org/\""
    else
        echo "remix/test mode"
        PUREDYNE_VERSION="Puredyne remix"
        BUILD_MIRRORS="--mirror-bootstrap \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot \"http://uk.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot-security \"http://security.ubuntu.com/ubuntu\""
    fi
}

brothconfig() {
lh config \
    $BUILD_MIRRORS \
    --mirror-binary "http://uk.archive.ubuntu.com/ubuntu" \
    --mirror-binary-security "http://security.ubuntu.com/ubuntu" \
    --binary-indices "true" \
    --bootappend-live "persistent preseed/file=/live/image/pure.seed quickreboot" \
    --hostname "puredyne" \
    --iso-application "Puredyne" \
    --iso-preparer "live-helper $VERSION" \
    --iso-publisher "Puredyne team; http://puredyne.goto10.org; puredyne-team@goto10.org" \
    --iso-volume $PUREDYNE_VERSION \
    --syslinux-splash "config/binary_syslinux/splash.png" \
    --syslinux-timeout "10" \
    --syslinux-menu "true" \
    --username "lintian" \
    --language "en_US.UTF-8" \
    --linux-packages $PUREDYNE_LINUX \
    --linux-flavours "rt" \
    --archive-areas "main restricted universe multiverse" \
    --architecture $PUREDYNE_ARCH \
    --mode "ubuntu" \
    --distribution "karmic" \
    --initramfs "live-initramfs" \
    --apt "aptitude" \
    --apt-recommends "false" \
    --keyring-packages "ubuntu-keyring medibuntu-keyring akirad-keyring-and-mirrors puredyne-keyring"
}

stock() {
    cp -r $BROTH_DIRECTORY/stock/* $BUILD_DIRECTORY/config/
    rm -rf $BUILD_DIRECTORY/config/chroot_local-hooks
    mv $BUILD_DIRECTORY/config/chroot_local-hooks-common $BUILD_DIRECTORY/config/chroot_local-hooks
    if [ -d $BUILD_DIRECTORY/config/chroot_local-hooks-$PACKAGES_LISTS ]
    then
        cp $BUILD_DIRECTORY/config/chroot_local-hooks-$PACKAGES_LISTS/* $BUILD_DIRECTORY/config/chroot_local-hooks/
    fi
    ## TEMP FIX SEE #504528 ---------
    mv $BUILD_DIRECTORY/config/chroot_local-packageslists/$PACKAGES_LISTS $BUILD_DIRECTORY/config/chroot_local-packageslists/$PACKAGES_LISTS.list
    ## ------------------------------
}

broken_config() {
# The following arguments are not accepted by lh config ATM
    echo "_DEBUG=\"true\"" >> $BUILD_DIRECTORY/config/common
    echo "APT_OPTIONS=\"--yes --force-yes\"" >> $BUILD_DIRECTORY/config/common
#    echo "APTITUDE_OPTIONS=\"--assume-yes\"" >> $BUILD_DIRECTORY/config/common 
}

serve() {
    if [ -e $BUILD_DIRECTORY/binary.iso ]; then
	md5sum -b $BUILD_DIRECTORY/binary.iso > binary.md5
	rsync -P $BUILD_DIRECTORY/binary.md5 10.80.80.40::puredyne-iso/carrot_and_coriander/puredyne-carrot_and_coriander-dev.md5
	rsync -P $BUILD_DIRECTORY/binary.iso 10.80.80.40::puredyne-iso/carrot_and_coriander/puredyne-carrot_and_coriander-dev.iso
    fi
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
    sudo lh build  2>&1| tee broth.log
#    serve
    if [ -e "$BUILD_DIRECTORY/binary.iso" ]; then
        echo "soup is ready!"
    else
        echo "$0 failed? $BUILD_DIRECTORY/binary.iso not found"
    fi
}

usage()
{
cat << EOF
BROTH - The mother of all soups
Copyright (C) 2008-2010  Puredyne Team
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, version 3 of the license.

usage: $0 options
   -h      Show this message
   -o      Choose output (CD or DVD or CUSTOM)
   -a      Choose target architecture (i386|amd64|lpia, default:i386)
   -p      Parent build directory (default:$PARENTBUILD_DIRECTORY)
EOF
}

if [ "$1" == "" ]; then
    usage ; exit 1
else
    while getopts "ho:a:p:" OPTION ; do
	case $OPTION in
	    h)  usage ; exit 1;;
            o)  OPTARG=`echo $OPTARG | tr '[:lower:]' '[:upper:]'`
		if [ $OPTARG == "CD" -o $OPTARG == "DVD" -o $OPTARG == "CUSTOM" ]; then
                    PACKAGES_LISTS="puredyne-$OPTARG"
		    echo "starting building of $PACKAGES_LISTS"
		else
                    echo "profile unknown, kthxbye"; exit -1
		fi
		;;
            a)  if [ $OPTARG == "i386" -o $OPTARG == "amd64" -o $OPTARG == "lpia" ]; then
                    PUREDYNE_ARCH=$OPTARG
                    BUILD_DIRECTORY="$PARENTBUILD_DIRECTORY/puredyne-build-$PUREDYNE_ARCH"
                    echo "building puredyne for $OPTARG"
                else
                    echo "architecture unknown, kthxbye"; exit -1
                fi
                ;;
	    p)  PARENTBUILD_DIRECTORY=$OPTARG 
		BUILD_DIRECTORY="$PARENTBUILD_DIRECTORY/puredyne-build-$PUREDYNE_ARCH"
		echo "parent build directory set to $PARENTBUILD_DIRECTORY"
		;;
	    *) echo "Not recognized argument, kthxbye"; exit -1 ;;
	esac
    done
fi

make_soup

