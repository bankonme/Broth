#!/bin/sh
# install libx11-noxcb outside of package management's reach
#
# go to your home directory, make tmpdur, get the package, create directory
# and change ownership to normal user for now... makes it safer for hamfisted
# types who might rm -rf /usr accidentally when given the chance...

cd
TMPDIR=$(mktemp -d)
cd $TMPDIR
wget -P $TMPDIR http://people.ubuntu.com/~bryce/Testing/libx11/libx11-6_1.1.3-1ubuntu2~noxcb_i386.deb
sudo mkdir -p /opt/LIBx11-noxcb
sudo chown $USER /opt/LIBx11-noxcb

# this produces a data.tar.gz, control.tar.gz and debian-binary file.
# The data.tar.gz contains the interesting bits, the rest is unimportant for this purpose

cd /opt/LIBx11-noxcb
ar x $TMPDIR/libx11-6_1.1.3-1ubuntu2~noxcb_i386.deb

# unpack data.tar.gz, move usr/lib -> /opt/LIBx11-noxcb/lib
# remove everything else which is not needed

tar zxf data.tar.gz
mv usr/lib .
rm -rf control.tar.gz data.tar.gz debian-binary usr

#revert ownership of the directory back to root)

cd
sudo chown -R root:root /opt/LIBx11-noxcb
rm -rf $TMPDIR

# that's all folks!
