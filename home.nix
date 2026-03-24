{ ... }:
{
  imports = [
    ./modules/home/default.nix
    ./modules/home/git.nix
    ./modules/home/shell.nix
    ./modules/home/btop.nix
    ./modules/home/fastfetch.nix
    ./modules/home/ghostty.nix
    ./modules/home/waybar.nix
    ./modules/home/niri.nix
    ./modules/home/neovim.nix
  ];
}
