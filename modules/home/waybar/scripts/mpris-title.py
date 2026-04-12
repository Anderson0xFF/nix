#!@python@/bin/python3
"""Título da música com marquee (scroll horizontal) para o waybar."""
import json
import subprocess
from html import escape as html_escape
from pathlib import Path

PLAYERCTL = "@playerctl@"
WIDTH = 20
SEPARATOR = "   •   "
STATE_DIR = Path("/tmp")
OFFSET_FILE = STATE_DIR / "waybar-mpris-offset"
LAST_TITLE_FILE = STATE_DIR / "waybar-mpris-last-title"


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


def emit(text: str, cls: str, tooltip: str = "") -> None:
    payload = {"text": text, "class": cls, "alt": cls}
    if tooltip:
        payload["tooltip"] = tooltip
    print(json.dumps(payload, ensure_ascii=False))


def marquee(full: str) -> str:
    if len(full) <= WIDTH:
        return full

    padded = full + SEPARATOR
    plen = len(padded)

    last_title = LAST_TITLE_FILE.read_text() if LAST_TITLE_FILE.exists() else ""
    try:
        offset = int(OFFSET_FILE.read_text()) if OFFSET_FILE.exists() else 0
    except ValueError:
        offset = 0

    if last_title != full:
        offset = 0

    LAST_TITLE_FILE.write_text(full)
    OFFSET_FILE.write_text(str((offset + 1) % plen))

    doubled = padded + padded
    return doubled[offset : offset + WIDTH]


def main() -> None:
    status = playerctl("status")
    if not status or status == "Stopped":
        emit("", "stopped")
        return

    title = playerctl("metadata", "title")
    artist = playerctl("metadata", "artist")
    album = playerctl("metadata", "album")
    player = playerctl("metadata", "--format", "{{playerName}}")

    full = f"{artist} · {title}" if artist else title
    display = html_escape(marquee(full))
    cls = status.lower()
    tooltip = html_escape(f"{player}: {status}\n{title}\n{artist}\n{album}")
    emit(display, cls, tooltip)


if __name__ == "__main__":
    main()
