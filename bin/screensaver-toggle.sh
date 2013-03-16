#!/bin/sh

if [ -z "`pgrep -f 'caffeine --activate'`" ]; then
    caffeine --activate
else
    caffeine --deactivate
fi
