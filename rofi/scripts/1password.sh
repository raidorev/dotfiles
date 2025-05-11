#!/bin/bash

# TODO: Make it a rofi script instead of a standalone one

set -euo pipefail

get_item_list() {
    op item list --vault "Personal" --categories Login --format json | jq -r '
    .[] | {
      title: .title,
      id: .id,
      username: .additional_information,
    } |
    "\(.title)\(if .username == null or .username == "—" then "" else " | \(.username)" end) [\(.id)]"'
}

get_item_details() {
    local id="$1"
    op item get "$id" --format json
}

get_field() {
    local id="$1"
    local label="$2"
    get_item_details "$id" | jq -r --arg label "$label" '.fields[]? | select(.label == $label) | .value'
}

copy_field() {
    local id="$1"
    local label="$2"
    get_field "$id" "$label" | wl-copy
    notify-send "Copied $label to clipboard"
}

open_url() {
    local id="$1"
    local url
    url=$(get_item_details "$id" | jq -r '.urls[0].href // empty')
    if [[ -n "$url" ]]; then
        xdg-open "$url" >/dev/null 2>&1
    else
        notify-send "No URL found for this item"
        exit 2
    fi
}

id_in_selection() {
    echo "$1" | grep -oE '\[[a-zA-Z0-9]+\]$' | tr -d '[]'
}

select_item() {
    get_item_list | rofi -dmenu -i -p "1Password"
}

select_action() {
    local id="$1"
    printf "Copy password\nCopy username\nCopy ID\nOpen URL" | rofi -dmenu -i -p "Action [$id]"
}

main() {
    if ! op signin; then
        exit
    fi

    local selected_item
    selected_item=$(select_item)
    [[ -z "$selected_item" ]] && exit

    local id
    id=$(id_in_selection "$selected_item")

    local action
    action=$(select_action "$id")
    [[ -z "$action" ]] && exit

    case "$action" in
    "Copy password") copy_field "$id" password ;;
    "Copy username") copy_field "$id" username ;;
    "Open URL") open_url "$id" ;;
    *) notify-send "Unknown action" ;;
    esac
}

main
