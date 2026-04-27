{ pkgs, ... }:
{
  imports = [
    ./langs/rust.nix
    ./langs/cpp.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    firefox
    wl-clipboard
    amdgpu_top
    xclip
    feh
    playerctl
  ];
}
