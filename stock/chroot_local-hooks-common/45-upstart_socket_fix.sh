#!/bin/bash
# needed to install some services that have been updated to upstart
# See https://bugs.launchpad.net/ubuntu/+source/upstart/+bug/430224

apt-get update

# rsyslog
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl
apt-get install rsyslog
rm /sbin/initctl
dpkg-divert --local --remove /sbin/initctl
mv /sbin/initctl.distrib /sbin/initctl
