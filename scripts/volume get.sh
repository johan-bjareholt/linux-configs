#!/bin/bash
VOLUME=$(amixer get Master | tr -d '[]' | grep "Playback.*%" | grep -oE '[0-9][0-9]%')
echo $VOLUME
