#!/bin/bash

# Uncomment this line if you want to download ST too

#git clone http://git.suckless.org/st/ 
#cd st

# Transpacency patch
#git apply ../transparency.diff

cd st

# Change config to mine
cp ../custom-config.h config.h


# Make
make

# Install
sudo make install
