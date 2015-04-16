#!/bin/bash

STATUS=""

# Function to get mixer toggle status
function status(){
	STATUS=$(amixer get Master | tr -d '[]' | grep "Playback.*%" | grep -oE '[^ ]+$' | head -n 1)
	echo $STATUS
}

# Function to toggle volume
function toggle(){
	status()
	if [ STATUS = "on" ]
	  then
	    amixer -c 0 set Master mute
		echo muted
	else
	    for CHANNEL in "Master" "Headphone" "PCM" "Side" "Front" "LFE" "Surround" "Center"
	      do
	        amixer -c 0 set $CHANNEL unmute
	    done
		echo unmuted
	fi

}

function increase(){
	amixer -c 0 set Master $1%+
	echo "V" > /tmp/panelfifo
}
function decrease(){
	amixer -c 0 set Master $1%-
	echo "V" > /tmp/panelfifo
}


# Get current volume %
if [ $1 = "get" ]; then
	VOLUME=$(amixer get Master | tail -n 1 | cut -d '[' -f 2 | sed 's/%.*//g')
	echo $VOLUME
# Raise volume
elif [ $1 = "increase" ]; then
	increase $2
# Decrease volume
elif [ $1 = "decrease" ]; then
	decrease $2
elif [ $1 = "status" ]; then
	status
# Toggle volume
elif [ $1 = "toggle" ]; then
	toggle
# Nope
else
	echo "Invalid parameter"
fi
