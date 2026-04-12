#!@python@/bin/python3
"""Botão previous para o waybar via playerctl."""
import json
import subprocess

PLAYERCTL = "@playerctl@"

GLYPH_PREV = "\uf04a"  # nf-fa-backward


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
    if not status or status == "Stopped":
        print(json.dumps({"text": "", "class": "stopped", "alt": "stopped"}))
        return

    cls = status.lower()
    text = f'<span font="Symbols Nerd Font Mono 14">{GLYPH_PREV}</span>'
    payload = {"text": text, "class": cls, "alt": cls, "tooltip": "Anterior"}
    print(json.dumps(payload, ensure_ascii=False))


if __name__ == "__main__":
    main()
