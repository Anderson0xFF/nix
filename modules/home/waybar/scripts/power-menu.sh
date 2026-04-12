#!/usr/bin/env bash
set -euo pipefail

# Fecha instancia anterior (toggle: clique abre, clique fecha)
pkill -x fuzzel 2>/dev/null && exit 0

chosen=$(printf '%s\n' \
  '󰌾  Lock' \
  '󰗽  Logout' \
  '󰒲  Hibernate' \
  '󰜉  Reboot' \
  '󰐥  Shutdown' \
| @fuzzel@ --dmenu \
    --hide-prompt \
    --lines 5 \
    --width 14 \
    --anchor top-right \
    --horizontal-pad 16 \
    --vertical-pad 8 \
    --inner-pad 0 \
    --border-radius 8 \
    --border-width 1 \
    --border-color cba6f755 \
    --background-color 11111bff \
    --text-color cdd6f4ff \
    --match-color cba6f7ff \
    --selection-color 313244ff \
    --selection-text-color cdd6f4ff \
    --font "JetBrainsMono Nerd Font:size=13" \
    --no-icons \
    --keyboard-focus on-demand \
) || exit 0

case "$chosen" in
  *Lock*)      @swaylock@ ;;
  *Logout*)    niri msg action quit ;;
  *Hibernate*) @systemctl@ hibernate ;;
  *Reboot*)    @systemctl@ reboot ;;
  *Shutdown*)  @systemctl@ poweroff ;;
esac
