#!/bin/bash

# Function to update bspwm panel
function ping(){
	echo "V" > /tmp/panelfifo
}

# Get current volume %
if [ "$1" = "get" ]; then
    VOLUME=$(amixer -D pulse get Master | tail -n 1 | grep -o '[0-9]*%')
    echo $VOLUME
# Get if pa us currently muted or not
elif [ "$1" = "status" ]; then
    # TODO: Fixme
	echo "eh"
# Raise volume
elif [ "$1" = "increase" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +3%
    ping
# Decrease volume
elif [ "$1" = "decrease" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -3%
    ping
# Toggle volume
elif [ "$1" = "toggle" ]; then
    pactl set-sink-mute combined toggle
    ping
# Fail
else
	echo "Invalid parameter"
fi
