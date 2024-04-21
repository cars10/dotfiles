#!/bin/bash

killall conky 
conky &

#killall nextcloud
#nextcloud &

killall nm-applet
nm-applet &

killall pasystray
pasystray &

bash /home/cars10/.screenlayout/test.sh


