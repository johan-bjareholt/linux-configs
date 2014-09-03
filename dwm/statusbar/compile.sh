#!/bin/bash
ALSA=$(pkg-config --cflags --libs alsa)
gcc -Wall -g -pedantic -std=c11 statusbar.c -lX11 -o statusbar $ALSA
