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
    ];
  };
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  services.envfs.enable = true;
  security.pam.services.swaylock = {};
}