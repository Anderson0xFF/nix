"""Ajusta brilho e mostra OSD.

Tenta backlight interno (via swayosd-client --brightness, que usa
brightnessctl por baixo). Se nao houver /sys/class/backlight, cai para
ddcutil (monitor externo) e mostra barra customizada no swayosd.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

STEP = 5


def has_internal_backlight() -> bool:
    backlight_dir = Path("/sys/class/backlight")
    return backlight_dir.is_dir() and any(backlight_dir.iterdir())


def run(cmd, check=True):
    return subprocess.run(cmd, check=check, capture_output=True, text=True)


def internal(direction: str) -> None:
    action = "raise" if direction == "up" else "lower"
    run(["swayosd-client", "--brightness", action])


def external(direction: str) -> None:
    sign = "+" if direction == "up" else "-"
    run(["ddcutil", "setvcp", "10", sign, str(STEP)])

    # ddcutil getvcp 10 --terse -> "VCP 10 C <current> <max>"
    result = run(["ddcutil", "getvcp", "10", "--terse"], check=False)
    progress = 0.0
    if result.returncode == 0:
        parts = result.stdout.split()
        if len(parts) >= 5:
            try:
                progress = int(parts[3]) / int(parts[4])
            except (ValueError, ZeroDivisionError):
                progress = 0.0

    run(
        [
            "swayosd-client",
            "--custom-progress",
            f"{progress:.2f}",
            "--custom-icon",
            "display-brightness-symbolic",
        ],
        check=False,
    )

    run(["pkill", "-RTMIN+8", "waybar"], check=False)


def main() -> int:
    direction = sys.argv[1] if len(sys.argv) > 1 else "up"
    if direction not in ("up", "down"):
        print("usage: brightness-osd up|down", file=sys.stderr)
        return 2

    if has_internal_backlight():
        internal(direction)
    else:
        external(direction)
    return 0


if __name__ == "__main__":
    sys.exit(main())
