#!/bin/bash
compton &
trayer --edge top --align right --transparent true --widthtype pixel --heighttype pixel --width 80 --height 10 --distancefrom right --distance 50 --tine 000000 &
$(
if [ $HOSTNAME = "johan-desktop" ]
  then
    dropbox start &
elif [ $HOSTNAME = "johan-laptop" ]
  then
    nm-applet &
    dropboxd
fi
)
