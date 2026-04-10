#!@python@/bin/python3
"""Botão play/pause para o waybar via playerctl."""
import json
import subprocess

PLAYERCTL = "@playerctl@"

# Glifos Nerd Font (FontAwesome)
GLYPH_PLAY = "\uf04b"   # nf-fa-play
GLYPH_PAUSE = "\uf04c"  # nf-fa-pause
GLYPH_STOP = "\uf04d"   # nf-fa-stop


def playerctl(*args: str) -> str:
    try:
        return subprocess.run(
            [PLAYERCTL, *args],
            capture_output=True,
            text=True,
            check=False,
        ).stdout.strip()
    except FileNotFoundError:
        return ""


def main() -> None:
    status = playerctl("status")
    if status == "Playing":
        glyph, cls = GLYPH_PAUSE, "playing"
    elif status == "Paused":
        glyph, cls = GLYPH_PLAY, "paused"
    else:
        glyph, cls = GLYPH_STOP, "stopped"

    text = f'<span font="Symbols Nerd Font Mono 14">{glyph}</span>'
    payload = {"text": text, "class": cls, "alt": cls, "tooltip": "Play/Pause"}
    print(json.dumps(payload, ensure_ascii=False))


if __name__ == "__main__":
    main()
