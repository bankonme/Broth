#!/bin/bash
# I want it my way :)

# pretty color in man
update-alternatives --set pager /usr/bin/most

# use urxvt daemon
update-alternatives --set x-terminal-emulator /usr/bin/urxvtcd
