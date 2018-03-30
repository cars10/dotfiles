#!/bin/bash
# set monitor
if [[ $(xrandr --listmonitors |grep HDMI1) ]]; then
  xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 1920x0 --output DP-1 --off --output eDP-1 --mode 1920x1080 --left-of HDMI-1
  sleep 1
fi

killall alsa-tray
alsa-tray &

killall conky 
conky &

killall compton 
compton -b

killall owncloud
owncloud &
