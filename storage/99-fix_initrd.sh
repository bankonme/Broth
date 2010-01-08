#!/bin/bash -e
#
# A script to unpack patch and repack the initrd in the binary stage.
# Fixes the usb boot problem after the vol_id removed in ubuntu.

INTRD=/home/aym3ric/puredyne-build-i386/binary/live/initrd.img # this works for the server
# uncomment and change to your user for the script to work
#INTRD=/home/anton/puredyne-build-i386/binary/live/initrd.img 

WDIR=$HOME/.tmprrr

if [ ! -r $INTRD ] ;then
    echo 'E: cannot find a valid initrd file at ' $INTRD ' aborting sequence'
    rm -rf $WDIR/
    exit 0
fi
rm -rf $WDIR/
mkdir -p $WDIR/old
mkdir -p $WDIR/new
cd $WDIR
cp $INTRD $WDIR/init.gz
gunzip $WDIR/init.gz 
cd $WDIR/old
cpio -i < ../init
#now we make our changes 

cat <<"EOF" |
diff -ruN orig/scripts/live-bottom/12fstab new/scripts/live-bottom/12fstab
--- orig/scripts/live-bottom/12fstab	2009-08-15 18:44:15.000000000 +0200
+++ new/scripts/live-bottom/12fstab	2009-08-15 18:44:32.000000000 +0200
@@ -66,7 +66,7 @@
 			continue
 		fi
 
-		/lib/udev/vol_id ${device%%[0-9]*} 2>/dev/null | grep -q "^ID_FS_USAGE=raid" && continue
+		/lib/udev/blkid -o value -s TYPE ${device%%[0-9]*} 2>/dev/null | grep -q "raid" && continue
 
 		magic=$(/bin/dd if="${device}" bs=4086 skip=1 count=1 2>/dev/null | /bin/dd bs=10 count=1 2>/dev/null) || continue
 
diff -ruN orig/scripts/live-helpers new/scripts/live-helpers
--- orig/scripts/live-helpers	2009-08-15 18:44:15.000000000 +0200
+++ new/scripts/live-helpers	2009-08-15 18:44:32.000000000 +0200
@@ -82,7 +82,7 @@
 	# fstype misreports LUKS devices
 	if is_luks "${1}"
 	then
-	    /lib/udev/vol_id -t ${1} 2>/dev/null
+	    /lib/udev/blkid -o value -s TYPE  ${1} 2>/dev/null
 	    return
 	fi
 
@@ -94,7 +94,7 @@
 		return 0
 	fi
 
-	/lib/udev/vol_id -t ${1} 2>/dev/null
+	/lib/udev/blkid -o value -s TYPE  ${1} 2>/dev/null
 }
 
 where_is_mounted ()
@@ -327,7 +327,7 @@
 				break
 			fi
 
-			if [ "$(/lib/udev/vol_id -l ${devname} 2>/dev/null)" = "${pers_label}" ]
+			if [ "$(/lib/udev/blkid -o value -s LABEL ${devname} 2>/dev/null)" = "${pers_label}" ]
 			then
 				echo "${devname}"
 				return

EOF
patch -p1

find ./ | cpio -H newc -o > ../initrd
cd $WDIR 
gzip initrd
cp initrd.gz $INTRD
#clean up 

rm -rf $WDIR/

exit 0

