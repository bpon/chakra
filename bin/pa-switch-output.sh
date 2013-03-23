#!/bin/bash

set -e

sinks=(`pacmd list-sinks | grep "index:" | sed -rn 's/.*index: ([0-9]+)/\1/p'`)
num_sinks=${#sinks[@]}

if [ "$num_sinks" = "0" ]; then
    echo "No sinks available"
    exit 1
fi

curr_sink=`pacmd list-sinks | grep "* index:" | sed -rn 's/.*index: ([0-9]+)/\1/p'`

if [ -z "$curr_sink" ]; then
    echo "Default sink is unknown"
    exit 1
fi

# Find current sink index
for ((i=0; i<$num_sinks; i++)); do
    if [ "${sinks[i]}" = "$curr_sink" ]; then
        next_sink=${sinks[(((i + 1) % num_sinks))]}
        break
    fi
done

# Move to next sink
echo "Setting default sink index to $next_sink"
pacmd set-default-sink $next_sink
echo

sink_inputs=$(pacmd list-sink-inputs | grep "index:" | sed -rn 's/.*index: ([0-9]+)/\1/p')

for i in $sink_inputs; do
    pacmd move-sink-input $i $next_sink
    echo
done

set +e
sink_name=$(pacmd list-sinks | grep -A 1 "index: $next_sink" | grep "name:" | sed -rn 's/.*name: .+\.([a-zA-Z0-9]+).*/\1/p')
notify-send "Audio output: $sink_name"
