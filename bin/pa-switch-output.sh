#!/bin/sh

set -e

num_sinks=$(pacmd list-sinks | grep "index:" | wc -l)
curr_sink=$(pacmd list-sinks | grep -B 1 "`pacmd info | sed -rn 's/Default sink name: (.+)/\1/p'`" | grep "index:" | sed -rn 's/.*index: ([0-9]+)/\1/p')

if [ "$num_sinks" = "0" ]; then
    echo "No sinks available"
    exit 1
fi

if [ -z "$curr_sink" ]; then
    echo "Default sink is unknown"
    exit 1
fi

next_sink=$((curr_sink % num_sinks + 1))

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
