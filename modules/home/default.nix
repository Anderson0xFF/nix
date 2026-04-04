{ config, lib, pkgs, ... }:
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
    swww
    waypaper
    zed-editor
    discord
    spotify
    thunar
    tumbler
    nautilus
    vscode
    dbeaver-bin
    jetbrains.datagrip
    zoom-us
    guvcview
    steam
    grim
    slurp
    wl-clipboard
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

  # RenderDoc procura o manifesto Vulkan em ~/.local/share/vulkan/implicit_layer.d
  # ao iniciar; sem ele, exibe uma caixa pedindo para rodar `renderdoccmd vulkanlayer
  # --register --system`, que tenta escrever em /etc (imutável no NixOS).
  # Este symlink satisfaz a checagem de forma puramente declarativa.
  xdg.dataFile."vulkan/implicit_layer.d/renderdoc_capture.json".source =
    "${pkgs.renderdoc}/share/vulkan/implicit_layer.d/renderdoc_capture.json";

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
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

    # Electron apps (VS Code, Discord, etc.) em Wayland nativo
    # NIXOS_OZONE_WL faz o wrapper NixOS injetar flags Wayland nos apps Electron.
    # Discord precisa disso (injeta --ozone-platform=wayland).
    # VS Code recebe --ozone-platform-hint=auto via wrapper, mas code-flags.conf
    # sobrescreve com --ozone-platform=wayland (flag mais forte).
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  };
}
