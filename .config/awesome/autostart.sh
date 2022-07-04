#!/bin/bash

killall conky 
conky &

killall nextcloud
nextcloud &

killall nm-applet
nm-applet &

killall pasystray
pasystray &

nvidia-settings --assign GPULogoBrightness=0

bash ~/Documents/resolution.sh

