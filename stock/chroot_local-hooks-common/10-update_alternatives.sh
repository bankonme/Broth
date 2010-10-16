#!/bin/bash
# I want it my way :)

# pretty color in man
update-alternatives --set pager /usr/bin/most

# note: in puredyne 9.11 we used urxvtcd (client/server) but due to debian #481123 that's unavailable
update-alternatives --set x-terminal-emulator /usr/bin/urxvt

# links is lovely but...
update-alternatives --set x-www-browser /usr/bin/firefox


