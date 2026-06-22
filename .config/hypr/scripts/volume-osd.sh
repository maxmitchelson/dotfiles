#!/usr/bin/env bash
# Volume OSD via dunst. Adjusts the default sink and shows a progress-bar
# notification that replaces itself on repeated presses (no stacking).
#
# Usage:
#   volume-osd.sh up      # raise 5% (capped at 100%)
#   volume-osd.sh down    # lower 5%
#   volume-osd.sh mute    # toggle mute
#   volume-osd.sh         # just (re)show current state

SINK="@DEFAULT_AUDIO_SINK@"
STEP="5%"
# Fixed id so every OSD replaces the previous one instead of stacking.
REPLACE_ID=2593
TIMEOUT=1200   # ms

case "$1" in
    up)   wpctl set-volume -l 1 "$SINK" "${STEP}+" ;;
    down) wpctl set-volume      "$SINK" "${STEP}-" ;;
    mute) wpctl set-mute        "$SINK" toggle ;;
esac

# Read current state: "Volume: 0.65 [MUTED]"
read -r _ raw muted <<<"$(wpctl get-volume "$SINK")"
vol=$(awk -v v="$raw" 'BEGIN { printf "%.0f", v * 100 }')

if [[ "$muted" == "[MUTED]" ]]; then
    glyph="󰝟"          # nf-md-volume_off
    title="Muted"
    bar=0
else
    bar=$vol
    title="Volume"
    if   (( vol == 0 )); then glyph="󰕿"   # volume_low
    elif (( vol < 34 )); then glyph="󰕿"   # volume_low
    elif (( vol < 67 )); then glyph="󰖀"   # volume_medium
    else                      glyph="󰕾"   # volume_high
    fi
fi

dunstify \
    -a "volume-osd" \
    -u low \
    -r "$REPLACE_ID" \
    -t "$TIMEOUT" \
    -h "int:value:$bar" \
    -h "string:x-dunst-stack-tag:volume-osd" \
    "${glyph}  ${title}" "${vol}%"
