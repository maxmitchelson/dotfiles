#!/bin/sh
current="$(powerprofilesctl get)"
case "$current" in
    power-saver) next="balanced" ;;
    balanced)    next="performance" ;;
    performance) next="power-saver" ;;
    *)           next="balanced" ;;
esac
powerprofilesctl set "$next"
pkill -RTMIN+8 waybar
