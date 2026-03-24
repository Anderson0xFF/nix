{ pkgs, lib, ... }:
{
  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "slight";
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font" "Symbols Nerd Font Mono"];
      sansSerif = ["Inter"];
      serif = ["Noto Serif"];
    };
  };

  fonts.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-color-emoji
  ] ++ builtins.filter lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
