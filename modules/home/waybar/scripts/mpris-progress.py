#!@python@/bin/python3
"""Barra de progresso textual da música atual para o waybar."""
import json
import subprocess

PLAYERCTL = "@playerctl@"
BAR_WIDTH = 10


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


def format_time(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    return f"{m}:{s:02d}"


def main() -> None:
    status = playerctl("status")
    if not status or status == "Stopped":
        emit("", "stopped")
        return

    cls = status.lower()

    try:
        position = float(playerctl("position") or 0)
        length_us = int(playerctl("metadata", "mpris:length") or 0)
    except ValueError:
        emit("─" * BAR_WIDTH, cls)
        return

    if length_us <= 0:
        emit("─" * BAR_WIDTH, cls)
        return

    length = length_us / 1_000_000
    filled = max(0, min(BAR_WIDTH, round((position / length) * BAR_WIDTH)))

    if filled >= BAR_WIDTH:
        bar = "━" * BAR_WIDTH
    else:
        bar = "━" * filled + "╸" + "─" * (BAR_WIDTH - filled - 1)

    tooltip = f"{format_time(position)} / {format_time(length)}"
    emit(bar, cls, tooltip)


if __name__ == "__main__":
    main()
