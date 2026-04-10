#!/usr/bin/env bash
status=$(@playerctl@ status 2>/dev/null)
case "$status" in
  Playing)
    icon=""
    class="playing"
    ;;
  Paused)
    icon=""
    class="paused"
    ;;
  *)
    icon=""
    class="stopped"
    ;;
esac
@jq@ -nc --arg text "$icon" --arg class "$class" '{text: $text, class: $class, alt: $class, tooltip: "Play/Pause"}'
