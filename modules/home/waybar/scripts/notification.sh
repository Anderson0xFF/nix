#!/usr/bin/env bash
count=$(@makoctl@ list -j | @jq@ -r 'length')
if [ "$count" -gt 0 ]; then
  icon='<span font="Symbols Nerd Font Mono">󱅫</span>'
  class="has-notifications"
else
  icon='<span font="Symbols Nerd Font Mono">󰂚</span>'
  class="none"
fi
@jq@ -nc --arg text "$icon" --arg class "$class" '{text: $text, class: $class, alt: $class}'
