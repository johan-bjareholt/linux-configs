#!/bin/sh

echo starting

function toggle {
    for channel in 'Master' 'Headphone' 'Front' 'Surround' 'Center' 'LFE' 'Side'; do
        amixer set $channel $mutemode > /dev/null 
    done
}

if [ '$1' = 'toggle' ]; then
    if $(amixer get Master | grep '\[on\]'); then
        echo "Muted"
        mutemode='mute'
        toggle
    elif $(amixer get Master | grep '\[off\]'); then
        echo "Unmuted"
        mutemode='unmute'
        toggle
    else
        echo "An error occured"
    fi
elif [ '$1' = 'volume' ]; then
    echo $(amixer get Master | grep '[[1-9]%]' | cut -d ' ' -f 5)
else:
    echo 'Invalid argument'
fi

echo done
