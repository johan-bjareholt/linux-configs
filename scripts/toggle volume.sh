#!/bin/bash
STATUS=$(amixer get Master | tr -d '[]' | grep "Playback.*%" | grep -oE '[^ ]+$')


if [ "$STATUS" = "on" ]
  then
    amixer -c 0 set Master mute
else
    for CHANNEL in "Master" "Headphone" "PCM" "Side" "Front" "LFE" "Surround" "Center"
      do
        amixer -c 0 set $CHANNEL unmute
    done
fi


