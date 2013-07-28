#!/bin/bash

## Toggles display modes and audio output

set -e

audio_output=`pa-switch-output.sh | grep "Audio output: " | cut -d " " -f 3`

# Set display mode based on audio output
# Hardcode displays for now
display0=`xrandr --current | grep " connected " | cut -d " " -f 1 | grep DVI | head -n 1`
display1=`xrandr --current | grep " connected " | cut -d " " -f 1 | grep HDMI | head -n 1`

if [ -n "$display1" ]; then
    if [ "$audio_output" == "hdmi" ]; then
        xrandr --output "$display1" --auto --right-of "$display0"
    else
        xrandr --output "$display1" --off
    fi
fi
