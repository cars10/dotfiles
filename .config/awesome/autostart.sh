#!/bin/bash
# set monitor
if [[ $(xrandr --listmonitors |grep HDMI) ]]; then
  xrandr --output VIRTUAL1 --off --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --off --output DP2 --off
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

killall nm-applet
nm-applet &
