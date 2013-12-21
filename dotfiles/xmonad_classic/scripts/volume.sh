#!/bin/sh
setChannel () {
  amixer set $1 $2 $3
}

setAllChannels () {
  for channel in 'Master' 'Headphone' 'Front' 'Surround' 'Center' 'LFE' 'Side'; do
    amixer set $channel $1
  done
}

getVolume () {
  volume=$(amixer get Master | grep '[1-9]%' | cut -d ' ' -f 6 | grep -o '[0-9]*' )
}

toggleVolume () {
  if amixer get Master | grep "\[on\]"; then
    setAllChannels "mute"
  else
    setAllChannels "unmute"
  fi
}

getVolumeIcon () {
  getVolume
  iconbasedir='/usr/share/icons/elementary/status/symbolic/'
  if [ $volume -eq 0 ]; then
    icon=''$iconbasedir'audio-volume-muted-symbolic.svg'
  elif [ $volume -lt 35 ]; then
    icon=''$iconbasedir'audio-volume-low-symbolic.svg'
  elif [ $volume -lt 65 ]; then
    icon=''$iconbasedir'audio-volume-medium-symbolic.svg'
  else
    icon=''$iconbasedir'audio-volume-high-symbolic.svg'
  fi
}


volumeNotification () {
  getVolume
  getVolumeIcon
  notify-send " " --icon=$icon $text$volume'%'
}

if [ $1 == 'raise' ]; then
  setChannel "Master 1+ unmute"
  volumeNotification "raise"
elif [ $1 == 'lower' ]; then
  setChannel "Master 1- unmute"
  volumeNotification "lower"
elif [ $1 == 'toggle' ]; then
  toggleVolume
elif [ $1 == 'mute' ]; then
  setAllChannels "mute"
elif [ $1 == 'unmute' ]; then
  setAllChannels "unmute"
elif [ $1 == 'getvolume' ]; then
  getVolume
  echo $volume
fi
