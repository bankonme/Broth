#!/bin/bash 
#DEVICE=/dev/sda
DIR=$HOME
MBR=puredyne-usb-mbr

cd $DIR

if [ -z "$1" ] ; then
    echo Usage: $0 [broth iso] [DEVICE] 
    echo Make sure you do this on the right device!
    echo WILL WIPE YOUR HARDDRIVE with no WARNING!!
    echo 'You need the MBR for the key in' $DIR/$MBR    
    echo ''
fdisk -l|grep Disk
    
    echo 'select your usb device from above'
exit 0

fi


cd $DIR
echo 'copy partition table.'
dd of=$2 if=$MBR bs=512 count=1
sudo mkfs.vfat -n puredyne $2'1'
echo 'do some stuff'

sudo /sbin/lilo -M $2
mkdir -p $DIR/iso $DIR/usb

echo 'mount iso and key'
sudo mount $2'1' $DIR/usb
sudo mount -o loop $1 $DIR/iso

echo 'copying files...'
sudo cp -av $DIR/iso/* $DIR/usb/
# dont forget to copy .disk b/rother!
echo 'changing bits and bytes'
cd $DIR/usb
sudo mv isolinux/* .
sudo rm -rf isolinux/
sudo sed -i 's/\/isolinux//g' *.cfg
sudo sed -i 's/\/isolinux//g' *.txt
sudo mv isolinux.cfg syslinux.cfg
sudo mv isolinux.bin syslinux.bin

echo 'clealypamaining up'
cd ..
sudo umount $DIR/usb
sudo umount $DIR/iso

echo 'running syslinux'
syslinux $2'1'

echo 'formating  data partition'

sudo mkfs.ext2 -L live-rw $2'2'

echo '***** done!'

exit 0
