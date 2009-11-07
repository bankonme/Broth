#!/bin/bash
# This hook makes some changes on the default adduser.conf.
# At the moment it is used to switch the shell to zshell for all new users, 
# including the live user because this one is created at boot time.
# It also sets default extra groups for new users.

# We want Zsh!
sed -i 's/DSHELL=\/bin\/bash/DSHELL=\/bin\/zsh/g' /etc/adduser.conf

# We want awesome groups!
cat >> /etc/adduser.conf <<EOF
EXTRA_GROUPS="dialout cdrom floppy plugdev netdev audio video users games"
ADD_EXTRA_GROUPS=1
EOF
