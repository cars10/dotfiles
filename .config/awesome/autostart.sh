#!/bin/bash

killall conky 
conky &

killall nextcloud
nextcloud &

#killall nm-applet
#nm-applet &

bash ~/Documents/resolution.sh

