#!/usr/bin/env bash
status=$(@playerctl@ status 2>/dev/null)
if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
  @jq@ -nc '{text: "", class: "stopped", alt: "stopped"}'
  exit 0
fi

title=$(@playerctl@ metadata title 2>/dev/null)
artist=$(@playerctl@ metadata artist 2>/dev/null)
album=$(@playerctl@ metadata album 2>/dev/null)
player=$(@playerctl@ metadata --format '{{playerName}}' 2>/dev/null)

if [ -n "$artist" ]; then
  full="$artist · $title"
else
  full="$title"
fi

width=20
len=$(printf '%s' "$full" | @awk@ '{print length($0)}')

if [ "$len" -le "$width" ]; then
  display="$full"
else
  padded="$full   •   "
  plen=$(printf '%s' "$padded" | @awk@ '{print length($0)}')
  offset_file="/tmp/waybar-mpris-offset"
  last_title_file="/tmp/waybar-mpris-last-title"
  last_title=""
  [ -f "$last_title_file" ] && last_title=$(cat "$last_title_file")
  offset=0
  if [ "$last_title" = "$full" ] && [ -f "$offset_file" ]; then
    offset=$(cat "$offset_file")
  fi
  printf '%s' "$full" > "$last_title_file"
  next=$(( (offset + 1) % plen ))
  printf '%s' "$next" > "$offset_file"
  doubled="$padded$padded"
  display=$(printf '%s' "$doubled" | @awk@ -v o="$offset" -v w="$width" '{print substr($0, o + 1, w)}')
fi

class=$(echo "$status" | tr '[:upper:]' '[:lower:]')
tooltip="$player: $status\n$title\n$artist\n$album"
@jq@ -nc --arg text "$display" --arg class "$class" --arg tooltip "$tooltip" '{text: $text, class: $class, alt: $class, tooltip: $tooltip}'
