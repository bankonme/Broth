#!/bin/bash 
#DEVICE=/dev/sda
DIR=/home/anton
cd $DIR

if [ -z "$1" ] ; then
    echo Usage: $0 DEVICE
    echo Make sure you do this on the rigt device!!!!!!!!!!!!!!!!!!
    echo WILL WIPE YOUR HARDDRIVE with no WARNING!!!!!!!!!!!!!!!!!!
fdisk -l
    echo '************************************************************************'
exit 0

fi


echo 'making USB bootable cd on ' $1

echo 'waiting for usb to settle...' 
sleep 5

echo "* copy partition table on the key"
dd of=$1 if=puredyne-usb-mbr bs=512 count=1
echo 'done.'

echo '** copy over system partition data'
dd if=puredyne-partition1 of=$1'1' bs=512
echo 'done..'
read -p  "*** Remove key and then back in. Press any key to continue!"
sleep 3
echo '**** format data partition'
#mkfs.vfat -F 16 /dev/sda1                                                                           
mkfs.ext2 -L live-rw $1'2'

echo '***** done!'
exit 0