"""Pula faixa (next/previous) e mostra notificacao mako com capa do album.

Usa a hint `x-canonical-private-synchronous` para que pressionar varias
vezes substitua a notificacao anterior em vez de empilhar.
"""
from __future__ import annotations

import subprocess
import sys
import tempfile
import time
import urllib.request
from urllib.parse import urlparse

EXPIRE_MS = 5000
METADATA_WAIT_S = 0.3


def run(cmd, check=True):
    return subprocess.run(cmd, check=check, capture_output=True, text=True)


def playerctl_metadata(field: str) -> str:
    result = run(["playerctl", "metadata", field], check=False)
    return result.stdout.strip() if result.returncode == 0 else ""


def resolve_art(art_url: str):
    if not art_url:
        return None
    parsed = urlparse(art_url)
    if parsed.scheme == "file":
        return parsed.path
    if parsed.scheme in ("http", "https"):
        fd, tmp = tempfile.mkstemp(suffix=".jpg")
        try:
            urllib.request.urlretrieve(art_url, tmp)
            return tmp
        except Exception:
            return None
    return None


def main() -> int:
    action = sys.argv[1] if len(sys.argv) > 1 else "next"
    if action not in ("next", "previous"):
        print("usage: music-osd next|previous", file=sys.stderr)
        return 2

    run(["playerctl", action], check=False)
    time.sleep(METADATA_WAIT_S)

    title = playerctl_metadata("title")
    if not title:
        return 0
    artist = playerctl_metadata("artist")
    art_path = resolve_art(playerctl_metadata("mpris:artUrl"))

    cmd = [
        "notify-send",
        "--app-name=music",
        f"--expire-time={EXPIRE_MS}",
        "--hint=string:x-canonical-private-synchronous:music-osd",
    ]
    if art_path:
        cmd.append(f"--icon={art_path}")
    cmd.extend([title, artist])
    run(cmd, check=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
