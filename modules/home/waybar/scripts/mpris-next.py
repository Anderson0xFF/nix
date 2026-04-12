#!@python@/bin/python3
"""Botão next para o waybar via playerctl."""
import json
import subprocess

PLAYERCTL = "@playerctl@"

GLYPH_NEXT = "\uf04e"  # nf-fa-forward


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
    text = f'<span font="Symbols Nerd Font Mono 14">{GLYPH_NEXT}</span>'
    payload = {"text": text, "class": cls, "alt": cls, "tooltip": "Próxima"}
    print(json.dumps(payload, ensure_ascii=False))


if __name__ == "__main__":
    main()
