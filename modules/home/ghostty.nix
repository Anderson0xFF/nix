{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      #font-family = "JetBrainsMono Nerd Font";
      font-family = "Maple Mono";
      #theme = "Catppuccin Mocha";
      background = "#000000"; # Transparência com alpha (hex + cc para 80% de opacidade)
      # background-opacity = 0.8;
      font-size = 14;
      window-decoration = false;
      confirm-close-surface = false;
    };
  };
}
