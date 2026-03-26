{ lib, pkgs, ... }:
{
  home.username = "alynx";
  home.homeDirectory = "/home/alynx";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alacritty
    btop
    fastfetch
    ghostty
    swaybg
    zed-editor
    discord
    thunar
    vscode
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = ":";
    gtk4.extraConfig.gtk-decoration-layout = ":";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.theme = null;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  programs.fuzzel = {
    enable = true;
    settings.main = {
      icon-theme = "Adwaita";
      terminal = "ghostty";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";  # segue o tema GTK
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    size = 8;
    package = pkgs.adwaita-icon-theme;
  };

  home.sessionVariables = {
    # XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "8";
    COLOR_SCHEME = "prefer-dark";
    EDITOR = "nvim";
    VISUAL = "nvim";
    QT_QPA_PLATFORMTHEME = lib.mkForce "xdgdesktopportal";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
