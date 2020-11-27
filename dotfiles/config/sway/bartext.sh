#!/bin/bash
VOL=$(pacmd list-sinks | grep 'volume: front-left:' | awk '{ print $5 }')
BAT=$(acpi | sed -e 's/Battery [0-9]: [A-Za-z]\+, \([0-9]\+%\).*/\1/g')
DATE=$(date +"%Y-%m-%d %H:%M")
echo "vol $VOL | bat $BAT | $DATE"
