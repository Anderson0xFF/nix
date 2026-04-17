{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      postgresql
      postgresql.lib
      openssl
      glib
      gtk3
      gtk4
      libadwaita
      gsettings-desktop-schemas

      # Windowing / input (winit)
      wayland
      libxkbcommon
      libx11
      libxcursor
      libxrandr
      libxi

      # GPU / Vulkan
      vulkan-loader
    ];
  };
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  services.envfs.enable = true;
  security.pam.services.swaylock = {};
}