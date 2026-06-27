#!/usr/bin/env bash
# wofi-based network menu for waybar: shows connectivity status + switch wifi networks.

set -uo pipefail

wofi() { command wofi --dmenu --insensitive --cache-file /dev/null "$@"; }

notify() { notify-send "Network" "$1"; }

while true; do
    active="$(nmcli -t -f NAME,TYPE connection show --active \
        | awk -F: '$2 ~ /wireless|ethernet/ {print $1}' | head -n1)"
    wifi_state="$(nmcli -t -f WIFI radio | head -n1)"

    # Cached reachability (no 'check' -> instant, non-blocking).
    conn="$(nmcli -t networking connectivity 2>/dev/null)"
    case "$conn" in
        full)    inet="󰖟  Internet: online" ;;
        limited) inet="󰤟  Internet: limited (no route out)" ;;
        portal)  inet="󰤟  Internet: captive portal" ;;
        none)    inet="󰪎  Internet: offline" ;;
        *)       inet="󰪎  Internet: unknown" ;;
    esac

    if [[ "$wifi_state" == "enabled" ]]; then
        status="${active:+On: $active — }$inet"
        toggle="󰖪  Turn Wi-Fi off"
    else
        status="󰖪  Wi-Fi disabled${active:+ — On: $active — $inet}"
        toggle="󰖩  Turn Wi-Fi on"
    fi

    menu="$status"$'\n'"$toggle"$'\n'"󰑐  Rescan"

    ssids=()
    declare -A secure=()   # ssid -> non-empty if the network needs a password
    if [[ "$wifi_state" == "enabled" ]]; then
        # Show the cached scan instantly (no blocking). NetworkManager keeps it
        # reasonably fresh on its own; we also nudge a background rescan below so
        # the *next* open is up to date.
        list="$(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list --rescan no)"
        if [[ -z "$list" ]]; then
            # Nothing cached yet (e.g. first run after boot) — scan once, blocking.
            nmcli device wifi rescan >/dev/null 2>&1
            list="$(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list --rescan no)"
        else
            # Detached refresh so it survives this script exiting; ignore rate-limit errors.
            setsid -f nmcli device wifi rescan >/dev/null 2>&1 || true
        fi
        while IFS=: read -r inuse signal security ssid; do
            [[ -z "$ssid" ]] && continue
            ssids+=("$ssid")
            secure["$ssid"]="$security"
            mark=" "; [[ "$inuse" == "*" ]] && mark="*"
            lock="  "; [[ -n "$security" ]] && lock="󰌾"
            menu+=$'\n'"$(printf '%s %3s%%  %s %s' "$mark" "$signal" "$lock" "$ssid")"
        # Collapse multiple BSSIDs of the same SSID (2.4/5GHz, mesh nodes) into one
        # row: keep the strongest signal, and the in-use '*' if any band is active.
        done < <(printf '%s\n' "$list" | awk -F: '
            {
                inuse=$1; signal=$2; security=$3
                ssid=$0; sub(/^[^:]*:[^:]*:[^:]*:/, "", ssid)
                s = signal + 0
                if (!(ssid in seen) || s > sig[ssid]) {
                    seen[ssid]; sig[ssid] = s; sec[ssid] = security
                }
                if (inuse == "*") active[ssid]
            }
            END {
                for (ss in seen)
                    printf "%s:%s:%s:%s\n", (ss in active ? "*" : " "), sig[ss], sec[ss], ss
            }' | sort -t: -k2 -rn)
    fi

    choice="$(printf '%s' "$menu" | wofi --width 460 --height 420 --prompt Network)" || exit 0
    [[ -z "$choice" ]] && exit 0

    case "$choice" in
        "$status") exit 0 ;;
        *"Turn Wi-Fi off"*) nmcli radio wifi off; continue ;;
        *"Turn Wi-Fi on"*)  nmcli radio wifi on;  sleep 2; continue ;;
        *"Rescan"*)         nmcli device wifi rescan >/dev/null 2>&1; sleep 2; continue ;;
    esac

    # Match the chosen line against the real SSID list (line ends with the SSID).
    target=""
    for s in "${ssids[@]}"; do
        [[ "$choice" == *"$s" ]] && { [[ ${#s} -gt ${#target} ]] && target="$s"; }
    done
    [[ -z "$target" ]] && exit 0

    if nmcli -t -f NAME connection show | grep -qxF "$target"; then
        # Known network — bring it up (NM already has the secret).
        nmcli connection up id "$target" || notify "Failed to connect to $target"
    elif [[ -z "${secure[$target]:-}" ]]; then
        # Open network — connect directly, no profile/password needed.
        nmcli device wifi connect "$target" || notify "Failed to connect to $target"
    else
        # Secured & unknown — ask for the password BEFORE any connect attempt,
        # so cancelling never leaves a half-created profile behind.
        # wofi suppresses its in-box prompt label in --password mode, so the
        # network name is shown via a notification instead.
        notify-send -t 5000 -i dialog-password "Wi-Fi" "Enter the password for “$target”"
        pass="$(printf '' | command wofi --conf "$HOME/.config/wofi/pass.conf" \
                --style "$HOME/.config/wofi/pass.css" \
                --password --exec-search --cache-file /dev/null)" || exit 0
        [[ -z "$pass" ]] && exit 0
        if ! nmcli device wifi connect "$target" password "$pass"; then
            nmcli connection delete "$target" 2>/dev/null  # don't keep a bad attempt
            notify "Wrong password or failed to connect to $target"
        fi
    fi
    exit 0
done
