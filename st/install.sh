#!/bin/bash

rm -r st-0.5*

wget http://git.suckless.org/st/snapshot/st-0.5.tar.bz2
tar xvf st-0.5.tar.bz2
cd st-0.5

# Transpacency patch
patch -p1 < ../transparency.diff

# Change config to mine
cp ../custom-config.h config.h


# Make
make

# Install
sudo make install
