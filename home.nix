{ ... }:
{
  imports = [
    ./modules/home/default.nix
    ./modules/home/git.nix
    ./modules/home/shell.nix
    ./modules/home/btop.nix
    ./modules/home/fastfetch.nix
    ./modules/home/ghostty.nix
    ./modules/home/waybar
    ./modules/home/walker
    ./modules/home/niri.nix
    ./modules/home/neovim.nix
    ./modules/home/hyprlock.nix
    ./modules/home/swayidle.nix
    ./modules/home/docker-tray.nix
  ];
}
