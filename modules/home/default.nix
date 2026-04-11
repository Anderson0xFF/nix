{ config, lib, pkgs, ... }:
let
  brightnessOsd = pkgs.writers.writePython3Bin "brightness-osd" {
    flakeIgnore = [ "E501" ];
  } (builtins.readFile ./scripts/brightness_osd.py);

  musicOsd = pkgs.writers.writePython3Bin "music-osd" {
    flakeIgnore = [ "E501" ];
  } (builtins.readFile ./scripts/music_osd.py);

  brightnessOsdWrapped = pkgs.symlinkJoin {
    name = "brightness-osd";
    paths = [ brightnessOsd ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/brightness-osd \
        --prefix PATH : ${lib.makeBinPath [
          pkgs.swayosd
          pkgs.ddcutil
          pkgs.procps
        ]}
    '';
  };

  musicOsdWrapped = pkgs.symlinkJoin {
    name = "music-osd";
    paths = [ musicOsd ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/music-osd \
        --prefix PATH : ${lib.makeBinPath [
          pkgs.playerctl
          pkgs.libnotify
        ]}
    '';
  };
in
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
    awww
    eza
    bat
    yazi
    waypaper
    zed-editor
    discord
    discordo
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
    mangohud
    notify-desktop
    wl-clipboard
    wiremix
    swayosd
    brightnessctl
    playerctl
  ] ++ [ brightnessOsdWrapped musicOsdWrapped ];

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

  services.mako = {
    enable = true;
    settings = {
      background-color = "#11111be6";
      text-color = "#cdd6f4";
      border-color = "#cba6f755";
      progress-color = "over #cba6f755";

      border-size = 1;
      border-radius = 14;

      font = "JetBrainsMono Nerd Font 12";

      width = 360;
      height = 120;
      margin = 10;
      padding = "14,18";
      outer-margin = 10;

      anchor = "top-right";
      layer = "overlay";
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      icons = true;
      max-icon-size = 48;
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
