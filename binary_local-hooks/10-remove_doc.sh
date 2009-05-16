#!/bin/bash
# remove the default doc folder
# yes, it's not nice, but until we have a proper root doc
# folder, we don't want to have pure:dyne users to be redirected
# to Debian for pure:dyne specific issues.
rm -rf /home/live/puredyne-live/binary/doc 
