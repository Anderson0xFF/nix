{ pkgs, ... }:
{
  home.username = "alynx";
  home.homeDirectory = "/home/alynx";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  # Pacotes de usuário
  home.packages = with pkgs; [
    ghostty
  ];

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Anderson Silva";
        email = "andersonvsc1998@gmail.com";
      };
    };
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.zoxide.enableZshIntegration = true;

  # Variáveis de ambiente
  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "16";
    HYPRCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    HYPRCURSOR_SIZE = "16";
    COLOR_SCHEME = "prefer-dark";
    EDITOR = "nvim";
    VISUAL = "nvim";
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # Ghostty
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      theme = "Catppuccin Mocha";
      font-size = 12;
      window-decoration = false;
      confirm-close-surface = false;
    };
  };

  # Niri: habilitado via programs.niri.enable = true no configuration.nix (NixOS level)
}
