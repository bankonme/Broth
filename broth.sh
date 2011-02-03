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
#    Copyright (C) 2008-2011 Puredyne Team
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


## What are we cooking?
#######################

BUILDER=$(whoami)
BROTH_DIRECTORY=$(pwd)
PUREDYNE_LINUX="linux-image"
PUREDYNE_ARCH="i386"
PUREDYNE_SOUP="gazpacho"
PUREDYNE_VERSION="1010"
PARENTBUILD_DIRECTORY="/home/$BUILDER"
BUILD_DIRECTORY="$PARENTBUILD_DIRECTORY/puredyne-build-$PUREDYNE_ARCH"


## How you like them soups?
###########################

prepare_kitchen()
{
    # Kernel specific settings
    if [ "${PUREDYNE_ARCH}" == "i386" ]
    then
        PUREDYNE_LINUX_FLAVOUR="2.6-liquorix-686"
    elif [ "${PUREDYNE_ARCH}" == "amd64" ]
    then
        PUREDYNE_LINUX_FLAVOUR="2.6-liquorix-amd64"
    fi

    # builder specific settings
    if [ "${BOB_THE_BUILDER}" == "1" ]
    then
        BUILD_MIRRORS="--mirror-bootstrap \"http://gb.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot \"http://gb.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot-security \"http://security.ubuntu.com/ubuntu\""
    else
        PUREDYNE_SOUP="${PUREDYNE_SOUP} remix"
        BUILD_MIRRORS="--mirror-bootstrap \"http://gb.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot \"http://gb.archive.ubuntu.com/ubuntu\" \
        --mirror-chroot-security \"http://security.ubuntu.com/ubuntu\""
    fi

    # create or clean existing kitchen
    if [ ! -d $BUILD_DIRECTORY ]
    then
        mkdir -p $BUILD_DIRECTORY
	cd $BUILD_DIRECTORY
    else
        cd $BUILD_DIRECTORY
        sudo lb clean
        rm -rf $BUILD_DIRECTORY/config
    fi
}

choose_recipe()
{
    lb config \
	$BUILD_MIRRORS \
	--ignore-system-defaults \
	--verbose \
	--mirror-binary "http://gb.archive.ubuntu.com/ubuntu" \
	--mirror-binary-security "http://security.ubuntu.com/ubuntu" \
	--binary-indices "true" \
	--bootappend-live "persistent preseed/file=/live/image/pure.seed quickreboot" \
	--hostname "puredyne" \
	--iso-application "Puredyne Live" \
	--iso-preparer "live-build VERSION" \
	--iso-publisher "Puredyne team; http://puredyne.org; puredyne-team@goto10.org" \
	--iso-volume "Puredyne ${PUREDYNE_SOUP}" \
	--binary-images "iso" \
	--syslinux-splash "config/binary_syslinux/splash.png" \
	--syslinux-timeout "10" \
	--syslinux-menu "true" \
	--username "lintian" \
	--language "en_US.UTF-8" \
	--linux-packages $PUREDYNE_LINUX \
	--linux-flavours $PUREDYNE_LINUX_FLAVOUR \
	--archive-areas "main restricted universe multiverse" \
	--architecture $PUREDYNE_ARCH \
	--mode "ubuntu" \
	--distribution "maverick" \
	--initramfs "live-initramfs" \
	--apt "apt" \
	--apt-recommends "false" \
	--apt-options "--yes --force-yes" \
	--keyring-packages "ubuntu-keyring medibuntu-keyring puredyne-keyring liquorix-keyrings liquorix-keyring liquorix-archive-keyring"
}

secret_ingredient()
{
    # copy the modified config over vanilla config
    cp -r $BROTH_DIRECTORY/stock/* $BUILD_DIRECTORY/config/

    # move common hooks
    HOOKS_ROOT="$BUILD_DIRECTORY/config/chroot_local-hooks"
    rm -rf $HOOKS_ROOT
    mv $HOOKS_ROOT-common $HOOKS_ROOT

    # copy target specific hooks
    if [ -d $HOOKS_ROOT-$PACKAGES_LISTS ]
    then
        cp $HOOKS_ROOT-hooks-$PACKAGES_LISTS/* $HOOKS_ROOT
    fi
    
    # copy architecture specific hooks
    if [ -d $HOOKS_ROOT-$PUREDYNE_ARCH ]
    then
        cp $HOOKS_ROOT-$PUREDYNE_ARCH/* $HOOKS_ROOT
    fi

    # choose the "master" package list
    PACKAGES_LISTS_DIR="$BUILD_DIRECTORY/config/chroot_local-packageslists"
    mv $PACKAGES_LISTS_DIR/$PACKAGES_LISTS $PACKAGES_LISTS_DIR/$PACKAGES_LISTS.list
    # append architecture specific packages
    cat $PACKAGES_LISTS_DIR/$PACKAGES_LISTS-$PUREDYNE_ARCH >> $PACKAGES_LISTS_DIR/$PACKAGES_LISTS.list 
}

make_soup()
{
    sudo lb build  2>&1| tee broth.log
}

serve_soup()
{
    if [ -e $BUILD_DIRECTORY/binary.iso ]
    then
	RELEASE="puredyne-1010-gazpacho-${PUREDYNE_MEDIUM}-${PUREDYNE_ARCH}-dev"
	mv $BUILD_DIRECTORY/binary.iso $BUILD_DIRECTORY/${RELEASE}.iso
	md5sum -b $BUILD_DIRECTORY/${RELEASE}.iso > ${RELEASE}.md5
	echo "soup is ready!"
	if [ "${BOB_THE_BUILDER}" == "1" ]
        then
	    rsync -P $BUILD_DIRECTORY/${RELEASE}.md5 10.80.80.40::puredyne-iso/${PUREDYNE_SOUP}/
	    rsync -P $BUILD_DIRECTORY/${RELEASE}.iso 10.80.80.40::puredyne-iso/${PUREDYNE_SOUP}/
        fi
    fi
}


## Au menu ce soir
##################

usage()
{
cat << EOF
BROTH - The mother of all soups
Copyright (C) 2008-2011  Puredyne Team
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, version 3 of the license.

usage: $0 options
   -h      Show this message
   -b      Bob the Builder mode
   -o      Choose output (CD, DVD or "CUSTOM")
   -a      Choose target architecture (i386|amd64, default:i386)
   -p      Parent build directory (default:$PARENTBUILD_DIRECTORY)
EOF
}


if [ "$1" == "" ]; then
    usage ; exit 1
else
    while getopts "ho:a:p:tb" OPTION ; do
	case $OPTION in
	    h)  usage ; exit 1;;
            o)  OPTARG=`echo $OPTARG | tr '[:lower:]' '[:upper:]'`
		if [ $OPTARG == "CD" -o $OPTARG == "DVD" -o $OPTARG == "CUSTOM" ]
		then
		    PUREDYNE_MEDIUM="$OPTARG"
                    PACKAGES_LISTS="puredyne-${PUREDYNE_MEDIUM}"
		    echo "starting building of $PACKAGES_LISTS"
		else
                    echo "profile unknown, kthxbye"; exit -1
		fi
		;;
            a)  if [ $OPTARG == "i386" -o $OPTARG == "amd64" ]; then
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
	    t)  TMPFS=1 # WIP, INACTIVE NOW
		echo "enabling tmpfs, hit CTRL-C if you do not know what you're doing"
		sleep 5s
		;;
            b)  BOB_THE_BUILDER=1
                echo "BOB THE BUILDER MODE!"
                ;;
	    *) echo "Not recognized argument, kthxbye"; exit -1 ;;
	esac
    done
fi


## Finally!
###########

prepare_kitchen
choose_recipe
secret_ingredient
make_soup
serve_soup

