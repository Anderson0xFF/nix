#!/usr/bin/env bash
status=$(@playerctl@ status 2>/dev/null)
case "$status" in
  Playing)
    glyph=""
    class="playing"
    ;;
  Paused)
    glyph=""
    class="paused"
    ;;
  *)
    glyph=""
    class="stopped"
    ;;
esac
icon="<span font=\"Symbols Nerd Font Mono 14\">$glyph</span>"
@jq@ -nc --arg text "$icon" --arg class "$class" '{text: $text, class: $class, alt: $class, tooltip: "Play/Pause"}'
