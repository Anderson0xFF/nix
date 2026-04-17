#!@python@/bin/python3
"""Botão next para o waybar via playerctl."""
import json
import subprocess

PLAYERCTL = "@playerctl@"

GLYPH_NEXT = "\uf04e"  # nf-fa-forward

PREFERENCE = ("spotify", "firefox", "chromium")


def _pref_key(name: str) -> int:
    for i, prefix in enumerate(PREFERENCE):
        if name.startswith(prefix):
            return i
    return len(PREFERENCE)


def select_player() -> str | None:
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


def main() -> None:
    player = select_player()
    status = playerctl("status", player=player) if player else ""
    if not status or status == "Stopped":
        print(json.dumps({"text": "", "class": "stopped", "alt": "stopped"}))
        return

    cls = status.lower()
    text = f'<span font="Symbols Nerd Font Mono 14">{GLYPH_NEXT}</span>'
    payload = {"text": text, "class": cls, "alt": cls, "tooltip": "Próxima"}
    print(json.dumps(payload, ensure_ascii=False))


if __name__ == "__main__":
    main()
