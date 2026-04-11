#!@python@/bin/python3
"""Mostra ícone e informações da distribuição Linux para o waybar."""
import json
import platform

DISTROS = {
    "nixos":    ("\U000f1105", "NixOS"),
    "ubuntu":   ("\uf31b",     "Ubuntu"),
    "debian":   ("\uf306",     "Debian"),
    "fedora":   ("\uf30a",     "Fedora"),
    "arch":     ("\uf303",     "Arch Linux"),
    "manjaro":  ("\uf312",     "Manjaro"),
    "gentoo":   ("\uf30d",     "Gentoo"),
    "opensuse": ("\uf314",     "openSUSE"),
    "alpine":   ("\uf300",     "Alpine"),
    "void":     ("\uf32e",     "Void Linux"),
    "endeavouros": ("\uf322",  "EndeavourOS"),
}
FALLBACK = ("\uf17c", "Linux")


def read_os_release() -> dict[str, str]:
    data: dict[str, str] = {}
    try:
        with open("/etc/os-release", encoding="utf-8") as fh:
            for line in fh:
                if "=" not in line:
                    continue
                key, _, value = line.strip().partition("=")
                data[key] = value.strip().strip('"')
    except OSError:
        pass
    return data


def main() -> None:
    info = read_os_release()
    distro_id = info.get("ID", "").lower()
    glyph, name = DISTROS.get(distro_id, FALLBACK)

    version = info.get("VERSION", info.get("VERSION_ID", ""))
    kernel = platform.release()

    tooltip_lines = [f"{name} {version}".strip(), f"Kernel {kernel}"]
    tooltip = "\n".join(tooltip_lines)

    text = f'<span font="Symbols Nerd Font Mono">{glyph}</span>'
    payload = {"text": text, "tooltip": tooltip}
    print(json.dumps(payload, ensure_ascii=False))


if __name__ == "__main__":
    main()
