#!/bin/bash

# 1. Grab the Sinks section
# 2. Strip out the vertical/horizontal lines (│, └, ─)
# 3. Clean up leading whitespace so the * or the ID is at the very start
devices=$(wpctl status | sed -n '/Sinks:/,/Sources:/p' | grep -E '[0-9]+\.' | sed 's/[│└─]//g' | sed 's/^[[:space:]]*//')

# 4. Show the menu
selected=$(echo "$devices" | fuzzel --dmenu -p "Select Audio Output: " --width 60)

# 5. Extract just the ID (ignoring the * if it's there)
if [ -n "$selected" ]; then
    # This grabs the first number it finds, even if a '*' is in front of it
    id=$(echo "$selected" | grep -oE '[0-9]+' | head -n 1)
    
    if [ -n "$id" ]; then
        wpctl set-default "$id"
        
        # Clean up the name for the notification (remove * and ID)
        name=$(echo "$selected" | sed 's/^\*//; s/^[0-9]*\. //')
        notify-send "Audio Switched" "Active: $name" -i audio-speakers
    fi
fi
