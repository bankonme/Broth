#!/bin/sh
# Installing PPAs from the chroot_sources dir won't pull the keys
# so we do it here, otherwise aptitude will always complain about
# untrusted sources.

# Please keep this script in sync with chroot_source PPAs!!!

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE49EC21 # Mozilla Team
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 432BB368 # Cinelerra
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B056DD89 # Koshi
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 79696851 # Puredyne Team
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4631BBEA # Tiheum
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F827E01E # PLT/Racket



