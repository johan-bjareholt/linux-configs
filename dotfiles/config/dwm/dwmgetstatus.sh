#!/bin/sh

xprop -root -f WM_NAME "8u" | sed -n -r 's/WM_NAME\(STRING\) = \"(.*)\"/\1/p'

