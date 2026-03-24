{ pkgs, ... }:
{
  home.username = "alynx";
  home.homeDirectory = "/home/alynx";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alacritty
    btop
    fastfetch
    fuzzel
    ghostty
    swaybg
    zed-editor
    discord
    vscodium
  ];

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    size = 8;
    package = pkgs.adwaita-icon-theme;
  };

  home.sessionVariables = {
    # XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "8";
    # HYPRCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    # HYPRCURSOR_SIZE = "16";
    COLOR_SCHEME = "prefer-dark";
    EDITOR = "nvim";
    VISUAL = "nvim";
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
