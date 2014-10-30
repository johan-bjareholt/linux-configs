#!/bin/bash
rm -rf dwm
git clone http://git.suckless.org/dwm/
cd dwm

# Apply patches
echo "Patching"

#echo "Patching gaps"
#patch -p1 < ../patches/uselessgap.diff
echo "Patching dual monitor statusbar"
patch -p1 < ../patches/dualstatus.diff
echo "Patching system tray improvements"
patch -p1 < ../patches/tray.diff
#echo "Patching transparent statusbar"
#patch -p1 < ../patches/transparentbar.diff
#echo "Patching center clock"
#patch -p1 < ../patches/centerclock.diff

