#!/usr/bin/env bash
status=$(@playerctl@ status 2>/dev/null)
if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
  @jq@ -nc '{text: "", class: "stopped", alt: "stopped"}'
  exit 0
fi

position=$(@playerctl@ position 2>/dev/null)
length_us=$(@playerctl@ metadata mpris:length 2>/dev/null)

if [ -z "$position" ] || [ -z "$length_us" ] || [ "$length_us" = "0" ]; then
  @jq@ -nc --arg class "$(echo "$status" | tr '[:upper:]' '[:lower:]')" '{text: "──────────", class: $class, alt: $class}'
  exit 0
fi

length=$(@awk@ -v l="$length_us" 'BEGIN { printf "%.3f", l / 1000000 }')
percent=$(@awk@ -v p="$position" -v l="$length" 'BEGIN { if (l <= 0) print 0; else printf "%.0f", (p / l) * 10 }')
if [ "$percent" -lt 0 ]; then percent=0; fi
if [ "$percent" -gt 10 ]; then percent=10; fi

bar=""
i=0
while [ "$i" -lt "$percent" ]; do
  bar="$bar━"
  i=$((i + 1))
done
if [ "$percent" -lt 10 ]; then
  bar="$bar╸"
  i=$((i + 1))
  while [ "$i" -lt 10 ]; do
    bar="$bar─"
    i=$((i + 1))
  done
fi

pos_fmt=$(@awk@ -v p="$position" 'BEGIN { m = int(p / 60); s = int(p) % 60; printf "%d:%02d", m, s }')
len_fmt=$(@awk@ -v l="$length" 'BEGIN { m = int(l / 60); s = int(l) % 60; printf "%d:%02d", m, s }')
tooltip="$pos_fmt / $len_fmt"
class=$(echo "$status" | tr '[:upper:]' '[:lower:]')

@jq@ -nc --arg text "$bar" --arg class "$class" --arg tooltip "$tooltip" '{text: $text, class: $class, alt: $class, tooltip: $tooltip}'
