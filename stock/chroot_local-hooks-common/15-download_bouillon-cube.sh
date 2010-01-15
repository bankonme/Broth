#!/bin/bash
# This hook will download the latest snapshot of some bouillon cube files
# This is needed until bouillon cube is mature enough to be packaged properly

bzr co lp:bouilloncube
mv bouilloncube/sh/make-live-device.sh /usr/sbin
rm -rf bouilloncube
