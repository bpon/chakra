#!/bin/sh

# Start screensaver daemon if not started
if [ -z "`pgrep -f xscreensaver`" ]; then
    xscreensaver -nosplash >/dev/null 2>&1 &
fi

# Toggle caffeine
if [ -z "`pgrep -f 'caffeine --activate'`" ]; then
    caffeine --activate
else
    caffeine --deactivate
fi
