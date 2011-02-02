#/bin/sh
# Add user lintian:live in live system
# THIS SHOULD NOT BE NEEDED
# IT'S MOST CERTAINLY A BUG
# FUCKIT

useradd -G dialout,cdrom,disk,floppy,plugdev,netdev,audio,video,users,games,sudo -s /bin/zsh -m -p $(perl -e 'print crypt($ARGV[0], "password")' "live") lintian
