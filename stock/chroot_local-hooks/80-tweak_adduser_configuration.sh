#!/bin/bash
# This hook makes some changes on the default adduser.conf.
# At the moment it only used to switch to zshell for all new users, 
# including the live user because this one is created at boot time.
# If needed this hook could be used to tweak a few more things, such
# as default groups.

# We want Zsh!
sed -i 's/DSHELL=\/bin\/bash/DSHELL=\/bin\/zsh/g' /etc/adduser.conf


