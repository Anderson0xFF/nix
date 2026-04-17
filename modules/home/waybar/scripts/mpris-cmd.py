#!@python@/bin/python3
"""Wrapper para on-click/on-scroll da waybar: aplica play-pause/next/previous
ao player MPRIS ativo, ignorando fantasmas em estado Stopped."""
import subprocess
import sys

PLAYERCTL = "@playerctl@"

PREFERENCE = ("spotify", "firefox", "chromium")
ALLOWED = {"play-pause", "next", "previous"}


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


def main() -> None:
    if len(sys.argv) != 2 or sys.argv[1] not in ALLOWED:
        print(f"uso: {sys.argv[0]} {{play-pause|next|previous}}", file=sys.stderr)
        sys.exit(2)
    cmd = sys.argv[1]
    player = select_player()
    if not player:
        return
    subprocess.run([PLAYERCTL, "--player", player, cmd], check=False)


if __name__ == "__main__":
    main()
