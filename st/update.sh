#!/bin/bash

# Update config
cp custom-config.h st-0.5/config.h

# Change directory
cd st-0.5

# Make
make

# Make install
sudo make install
