#!/bin/bash
cd c 
make
cp ../custom-config.h ./config.h
sudo make install
