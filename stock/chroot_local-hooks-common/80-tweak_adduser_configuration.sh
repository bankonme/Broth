#!/bin/bash
# This hook makes some changes on the default adduser.conf.
# At the moment it is used to switch the shell to zshell for all new users, 
# including the live user because this one is created at boot time.
# It also sets default extra groups for new users.

TARGETFILE="/etc/adduser.conf"

# We want Zsh!
sed -i 's|DSHELL=/bin/bash|DSHELL=/bin/zsh|g' "$TARGETFILE"

# We want awesome groups!
cat >> "$TARGETFILE" <<EOF
EXTRA_GROUPS="dialout cdrom disk floppy plugdev netdev audio video users games"
ADD_EXTRA_GROUPS=1
EOF
