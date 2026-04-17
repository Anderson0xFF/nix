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

PREFERENCE = ("spotify", "firefox", "chromium")


def _pref_key(name: str) -> int:
    for i, prefix in enumerate(PREFERENCE):
        if name.startswith(prefix):
            return i
    return len(PREFERENCE)


def select_player() -> str | None:
    """Retorna o player com status Playing (ou Paused, se nenhum tocar), ou None."""
    try:
        listing = subprocess.run(
            [PLAYERCTL, "-l"],
            capture_output=True,
            text=True,
            check=False,
        ).stdout.strip()
    except FileNotFoundError:
        return None
    names = [n for n in listing.splitlines() if n]
    if not names:
        return None

    playing, paused = [], []
    for name in names:
        st = subprocess.run(
            [PLAYERCTL, "--player", name, "status"],
            capture_output=True,
            text=True,
            check=False,
        ).stdout.strip()
        if st == "Playing":
            playing.append(name)
        elif st == "Paused":
            paused.append(name)

    pool = playing or paused
    if not pool:
        return None
    pool.sort(key=lambda n: (_pref_key(n), n))
    return pool[0]


def playerctl(*args: str, player: str | None = None) -> str:
    cmd = [PLAYERCTL]
    if player:
        cmd += ["--player", player]
    cmd += list(args)
    try:
        return subprocess.run(
            cmd,
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
    player = select_player()
    if not player:
        emit("", "stopped")
        return

    status = playerctl("status", player=player)
    if not status or status == "Stopped":
        emit("", "stopped")
        return

    title = playerctl("metadata", "title", player=player)
    artist = playerctl("metadata", "artist", player=player)
    album = playerctl("metadata", "album", player=player)
    player_name = playerctl("metadata", "--format", "{{playerName}}", player=player)

    full = f"{artist} · {title}" if artist else title
    display = html_escape(marquee(full))
    cls = status.lower()
    tooltip = html_escape(f"{player_name}: {status}\n{title}\n{artist}\n{album}")
    emit(display, cls, tooltip)


if __name__ == "__main__":
    main()
