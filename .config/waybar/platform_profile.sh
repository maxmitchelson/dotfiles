#!/bin/sh
profile="$(powerprofilesctl get)"
echo "{\"alt\": \"$profile\", \"tooltip\": \"$profile\"}"
