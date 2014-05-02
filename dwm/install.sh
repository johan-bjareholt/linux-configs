#!/bin/bash
cd dwm
make
cp ../custom-config.h ./config.h
sudo make install
