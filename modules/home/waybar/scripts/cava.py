#!@python@/bin/python3
"""Waveform via cava para o waybar, com colapso quando não há MPRIS."""
import json
import os
import signal
import subprocess
import sys
import tempfile
import time

CAVA = "@cava@"
PLAYERCTL = "@playerctl@"

BARS = 20
FRAMERATE = 30
BARS_ICONS = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
MPRIS_CHECK_INTERVAL = 1.0

CONFIG_TEMPLATE = f"""
[general]
bars = {BARS}
framerate = {FRAMERATE}
autosens = 1
lower_cutoff_freq = 50
higher_cutoff_freq = 10000

[input]
method = pipewire
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = {len(BARS_ICONS) - 1}
bar_delimiter = 59
frame_delimiter = 10

[smoothing]
noise_reduction = 0.95
"""


def mpris_active() -> bool:
    try:
        result = subprocess.run(
            [PLAYERCTL, "status"],
            capture_output=True,
            text=True,
            check=False,
        )
    except FileNotFoundError:
        return False
    status = result.stdout.strip()
    return status in ("Playing", "Paused")


def emit(text: str, cls: str) -> None:
    payload = {"text": text, "class": cls, "alt": cls}
    sys.stdout.write(json.dumps(payload, ensure_ascii=False) + "\n")
    sys.stdout.flush()


def emit_empty() -> None:
    emit("", "empty")


def main() -> None:
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".conf", delete=False
    ) as cfg:
        cfg.write(CONFIG_TEMPLATE)
        cfg_path = cfg.name

    proc = subprocess.Popen(
        [CAVA, "-p", cfg_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        bufsize=1,
    )

    def cleanup(*_):
        try:
            proc.terminate()
        except Exception:
            pass
        try:
            os.unlink(cfg_path)
        except Exception:
            pass
        sys.exit(0)

    signal.signal(signal.SIGTERM, cleanup)
    signal.signal(signal.SIGINT, cleanup)

    last_mpris_check = 0.0
    mpris_ok = False

    try:
        for line in proc.stdout:
            now = time.monotonic()
            if now - last_mpris_check >= MPRIS_CHECK_INTERVAL:
                mpris_ok = mpris_active()
                last_mpris_check = now

            if not mpris_ok:
                emit_empty()
                continue

            raw = line.strip().rstrip(";")
            if not raw:
                emit_empty()
                continue

            try:
                levels = [int(x) for x in raw.split(";") if x]
            except ValueError:
                continue

            if not levels:
                emit_empty()
                continue

            bar = "".join(
                BARS_ICONS[min(max(lv, 0), len(BARS_ICONS) - 1)]
                for lv in levels
            )
            emit(bar, "playing")
    finally:
        cleanup()


if __name__ == "__main__":
    main()
