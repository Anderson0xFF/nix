# Guia de Migração da Configuração NixOS

Referência para migrar a configuração atual para outra distribuição Linux.

**Hardware**: AMD RX 6700 XT (RDNA2), 48GB RAM, monitor DP-1 3840x2160 @ 240Hz

---

## Configurações de aplicativos (migram direto)

Esses arquivos não dependem do NixOS — basta copiar ou converter:

| Origem (NixOS) | Destino na nova distro |
|---|---|
| `modules/home/shell.nix` (Starship) | Copiar `.config/starship.toml` |
| `modules/home/niri.nix` | Converter para `~/.config/niri/config.kdl` |
| `modules/home/waybar.nix` | Converter para `~/.config/waybar/config` + `style.css` |
| `modules/home/ghostty.nix` | Converter para `~/.config/ghostty/config` |
| `modules/home/btop.nix` | Converter para `~/.config/btop/btop.conf` |
| `modules/home/swaylock.nix` | Converter para `~/.config/swaylock/config` |
| `modules/home/swayidle.nix` | Converter para `~/.config/swayidle/config` |
| `modules/home/fastfetch.nix` | Converter para `~/.config/fastfetch/config.jsonc` |
| `modules/home/git.nix` | `git config --global user.name/email` |
| `modules/home/neovim.nix` | NvChad funciona igual em qualquer distro |

---

## Pacotes

### Pacotes do sistema (`modules/system/packages.nix`)

| NixOS | Equivalente genérico |
|---|---|
| `git` | `git` |
| `wget` | `wget` |
| `htop` | `htop` |
| `firefox` | `firefox` |
| `wl-clipboard` | `wl-clipboard` |
| `xwayland-satellite` | `xwayland-satellite` |
| `xclip` | `xclip` |
| `feh` | `feh` |
| `postgresql` | `postgresql` |
| `glib`, `gtk3`, `gtk4`, `libadwaita` | Via gerenciador de pacotes da distro |

### Pacotes do usuário (`modules/home/default.nix`)

| NixOS | Equivalente genérico |
|---|---|
| `ghostty` | `ghostty` |
| `alacritty` | `alacritty` |
| `btop` | `btop` |
| `fastfetch` | `fastfetch` |
| `swaybg` | `swaybg` |
| `zed-editor` | `zed-editor` |
| `vscode` | `vscode` |
| `discord` | `discord` |
| `spotify` | `spotify` |
| `thunar` | `thunar` |
| `nautilus` | `nautilus` |
| `zoom-us` | `zoom` |
| `guvcview` | `guvcview` |
| `steam` | `steam` |

---

## Configuração de sistema

### Kernel

| NixOS | Como fazer em outra distro |
|---|---|
| `linuxPackages_zen` | Instalar `zen-kernel` (disponível em Arch, Gentoo, etc.) |
| Parâmetros de kernel AMD | Adicionar em `GRUB_CMDLINE_LINUX` no `/etc/default/grub` |

**Parâmetros de kernel para o RX 6700 XT** (copiar para `/etc/default/grub`):
```
amdgpu.gfxoff=0 amdgpu.dc=1 amd_iommu=on
```
> Esses parâmetros resolvem o bug de suspend/resume do RDNA2. O mesmo problema ocorrerá em qualquer distro sem eles.

### Bootloader

| NixOS | Como fazer em outra distro |
|---|---|
| GRUB EFI, 10 gerações | GRUB com `GRUB_DEFAULT=saved`, `update-grub` |
| Tema NixOS | Qualquer tema GRUB disponível online |

### Locale e timezone

```bash
# /etc/locale.gen
pt_BR.UTF-8 UTF-8
en_US.UTF-8 UTF-8

# /etc/locale.conf
LANG=pt_BR.UTF-8
LC_ALL=pt_BR.UTF-8

# Timezone
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
```

### Rede

| NixOS | Como fazer em outra distro |
|---|---|
| NetworkManager | Instalar e habilitar `NetworkManager` |
| DNS 1.1.1.1 + 9.9.9.9 | `/etc/resolv.conf` ou configurar no NetworkManager |

### Áudio

| NixOS | Como fazer em outra distro |
|---|---|
| PipeWire | Instalar `pipewire`, `pipewire-alsa`, `pipewire-pulse`, `rtkit` |
| ALSA 32-bit | Instalar `lib32-alsa-lib` (Arch) ou equivalente |

### AMD GPU

| NixOS | Como fazer em outra distro |
|---|---|
| `hardware.graphics.enable` | Driver `amdgpu` já incluso no kernel 5.x+ |
| 32-bit support | Instalar `lib32-mesa`, `lib32-vulkan-radeon` |
| Vulkan tools | `vulkan-tools`, `vulkan-radeon`, `vulkan-validation-layers` |

### Webcam virtual (v4l2loopback)

```bash
# Instalar o módulo
# Arch: pacman -S v4l2loopback-dkms
# Gentoo: emerge media-video/v4l2loopback

# Configurar em /etc/modprobe.d/v4l2loopback.conf
options v4l2loopback devices=1 video_nr=1 card_label="Virtual Camera" exclusive_caps=1
```

### Performance — sysctl

Criar `/etc/sysctl.d/99-performance.conf`:
```ini
# Swap conservador (48GB RAM)
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.page-cluster=0

# Rede
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr

# File watchers (IDEs)
fs.inotify.max_user_watches=1048576
```

### Performance — Zram

```bash
# Arch: pacman -S zram-generator
# Criar /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 4
compression-algorithm = zstd
```

### Performance — /tmp em tmpfs

Adicionar em `/etc/fstab`:
```
tmpfs /tmp tmpfs defaults,size=50%,mode=1777 0 0
```

### EarlyOOM

```bash
# Arch: pacman -S earlyoom
# Configurar /etc/default/earlyoom
EARLYOOM_ARGS="-m 5 -s 5 --avoid '(^|/)(code|electron|discord|spotify)$'"
```

### GameMode

```bash
# Arch: pacman -S gamemode lib32-gamemode
# Gentoo: emerge games-util/gamemode
# Usar: gamemoderun %command% no Steam
```

### Limites de arquivos

Adicionar em `/etc/security/limits.conf`:
```
alynx soft nofile 8192
alynx hard nofile 65536
```

### Usuário e grupos

```bash
usermod -aG networkmanager,wheel,docker,video alynx
chsh -s /bin/zsh alynx
```

### SSH

Editar `/etc/ssh/sshd_config`:
```
Port 22
PermitRootLogin no
PasswordAuthentication yes
AllowUsers alynx
X11Forwarding no
```

### XDG Portals

```bash
# Instalar: xdg-desktop-portal, xdg-desktop-portal-gtk, xdg-desktop-portal-gnome
# Para Niri, criar /etc/xdg/xdg-desktop-portal/niri-portals.conf
[preferred]
default=gnome;gtk;
```

### Serviços para habilitar

```bash
systemctl enable --now NetworkManager
systemctl enable --now pipewire pipewire-pulse
systemctl enable --now docker
systemctl enable --now sshd
systemctl enable --now thermald
systemctl enable --now auto-cpufreq
systemctl enable --now upower
systemctl enable --now greetd
```

### Power management

```bash
# auto-cpufreq: Arch AUR ou Gentoo
# Configurar /etc/auto-cpufreq.conf
[charger]
governor = performance
turbo = auto

[battery]
governor = powersave
turbo = never
```

---

## Ambiente de desenvolvimento

### Rust

```bash
# Via rustup (funciona em qualquer distro)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup toolchain install nightly
rustup component add rust-src rust-analyzer --toolchain nightly
```

### C++

| NixOS | Pacote genérico |
|---|---|
| `gcc` | `gcc` |
| `clang`, `llvm` | `clang`, `llvm` |
| `cmake` | `cmake` |
| `ninja` | `ninja` |

### LSPs (para NvChad)

```bash
# Via npm/pip/cargo dentro do Neovim com Mason
# nil (Nix LSP): cargo install nil
# typescript-language-server: npm install -g typescript-language-server
# lua-language-server: disponível em repos da maioria das distros
```

---

## Desktop

### Wayland — variáveis de ambiente

Adicionar em `~/.profile` ou `/etc/environment`:
```bash
EDITOR=nvim
VISUAL=nvim
GTK_THEME=Adwaita:dark
XCURSOR_THEME=Adwaita
XCURSOR_SIZE=8
QT_QPA_PLATFORMTHEME=xdgdesktopportal
QT_WAYLAND_DISABLE_WINDOWDECORATION=1
QT_QPA_PLATFORM=wayland;xcb
NIXOS_OZONE_WL=1
ELECTRON_OZONE_PLATFORM_HINT=wayland
```

### Tema

| NixOS | Como fazer em outra distro |
|---|---|
| GTK: Adwaita Dark | `gsettings set org.gnome.desktop.interface color-scheme prefer-dark` |
| Qt: adwaita-dark | Instalar `adwaita-qt`, definir `QT_STYLE_OVERRIDE=adwaita-dark` |
| Cursor: Adwaita 8 | `gsettings set org.gnome.desktop.interface cursor-theme Adwaita` |

### Fontes

```bash
# Instalar:
# - JetBrainsMono Nerd Font (https://www.nerdfonts.com)
# - Symbols Nerd Font Mono
# - Inter
# - Noto Fonts (noto-fonts, noto-fonts-emoji)

# Configurar /etc/fonts/local.conf ou ~/.config/fontconfig/fonts.conf
# Monospace: JetBrainsMono Nerd Font
# Sans: Inter
# Serif: Noto Serif
```

### Anyrun (launcher)

Launcher em Rust + GTK4 para Wayland. Instalar via pacote nativo da distro (`pacman -S anyrun`, AUR `anyrun-git`, ou `cargo install` a partir do repositório oficial).

Criar `~/.config/anyrun/config.ron` (ajustar os caminhos dos plugins conforme o prefixo em que o anyrun foi instalado — tipicamente `/usr/lib/anyrun/` ou `$HOME/.cargo/…/target/release/`):

```ron
Config(
  x: Fraction(0.5),
  y: Fraction(0.3),
  width: Absolute(600),
  height: Absolute(0),
  margin: 0,
  hide_icons: false,
  ignore_exclusive_zones: false,
  layer: Overlay,
  hide_plugin_info: true,
  close_on_click: true,
  show_results_immediately: true,
  max_entries: None,
  plugins: [
    "/usr/lib/anyrun/libapplications.so",
    "/usr/lib/anyrun/libsymbols.so",
    "/usr/lib/anyrun/librink.so",
  ],
)
```

Criar `~/.config/anyrun/style.css` com o mesmo CSS usado no módulo NixOS (cores do tema das ilhas da waybar, JetBrainsMono Nerd Font, border-radius 8px). Copiar o bloco `extraCss` de `modules/home/default.nix`.

---

## Sistemas Linux com configuração declarativa centralizada

Se quiser manter o estilo "tudo em um lugar" do NixOS em outra distro, estas são as opções:

### GNU Guix (mais próximo do NixOS)
- **O quê**: Distro declarativa baseada no Guix package manager, análogo ao Nix
- **Como funciona**: Um arquivo `config.scm` (Scheme/Guile) define todo o sistema — pacotes, serviços, usuários, kernel
- **Rollbacks**: Sim, igual ao NixOS
- **Contras**: Menos pacotes que o nixpkgs, curva de aprendizado em Scheme

### Nix + Home Manager em qualquer distro
- **O quê**: Instalar o Nix package manager em cima de Gentoo/Arch/Debian, usar Home Manager para gerenciar pacotes e dotfiles do usuário de forma declarativa
- **Como funciona**: Mantém os arquivos `.nix` atuais do `modules/home/` praticamente sem mudança
- **Contras**: A configuração do sistema (kernel, serviços) ainda é manual na distro host
- **Melhor opção se**: Quer migrar para Gentoo mas manter o Home Manager funcionando

### Fedora Silverblue / Kinoite
- **O quê**: Fedora com imagem de sistema imutável
- **Como funciona**: Sistema base fixo (ostree), pacotes adicionais via `rpm-ostree install` ou Flatpak
- **Contras**: Menos flexível que NixOS, sem rollback completo de configuração

### openSUSE MicroOS / Aeon
- **O quê**: Sistema transacional, atualizações atômicas
- **Como funciona**: `transactional-update` aplica mudanças em uma nova snapshot e reinicia
- **Contras**: Não é declarativo no sentido de "um arquivo define tudo"

### Ansible (em qualquer distro)
- **O quê**: Ferramenta de automação/IaC que pode gerenciar todo o sistema
- **Como funciona**: Playbooks YAML idempotentes que instalam pacotes, configuram serviços, copiam dotfiles
- **Contras**: Mais verboso que Nix, não tem rollbacks nativos, precisa rodar manualmente

### chezmoi (só dotfiles)
- **O quê**: Gerenciador de dotfiles com suporte a templates
- **Como funciona**: Um repositório Git central com todos os arquivos de `~/.config/`
- **Contras**: Não gerencia pacotes do sistema, só configurações do usuário

---

## Recomendação para Gentoo

A combinação mais próxima do NixOS em Gentoo é:

**Gentoo + Nix package manager + Home Manager**

1. Gentoo gerencia o sistema (kernel, serviços, drivers)
2. Nix gerencia pacotes do usuário de forma declarativa
3. Home Manager mantém os arquivos `modules/home/*.nix` quase sem modificação

Isso preserva a parte declarativa que mais impacta o dia a dia (dotfiles, pacotes do usuário) enquanto usa o Portage para o que ele faz melhor (kernel customizado, USE flags, drivers AMD).
