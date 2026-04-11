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

  programs.walker = {
    enable = true;
    runAsService = true;

    themes.catppuccin-pill = {
      style = ''
        @define-color window_bg_color rgba(17, 17, 27, 1.0);
        @define-color entry_bg_color rgba(30, 30, 46, 0.6);
        @define-color accent_bg_color #cba6f7;
        @define-color theme_fg_color #cdd6f4;
        @define-color subtext_color #9399b2;
        @define-color error_bg_color #f38ba8;
        @define-color error_fg_color #11111b;

        * {
          all: unset;
          font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font Mono", monospace;
          font-size: 15px;
        }

        .normal-icons { -gtk-icon-size: 16px; }
        .large-icons  { -gtk-icon-size: 32px; }
        scrollbar { opacity: 0; }

        .box-wrapper {
          background: @window_bg_color;
          padding: 10px 14px;
          border-radius: 8px;
          border: 1px solid alpha(@accent_bg_color, 0.33);
          color: @theme_fg_color;
        }

        .search-container {
          border-radius: 8px;
        }

        .input {
          caret-color: @theme_fg_color;
          background: @entry_bg_color;
          padding: 6px 10px;
          border-radius: 8px;
          color: @theme_fg_color;
        }

        .input placeholder { opacity: 0.5; }

        .list {
          color: @theme_fg_color;
        }

        .item-box {
          border-radius: 8px;
          padding: 6px 10px;
        }

        child:selected .item-box,
        row:selected .item-box {
          background: alpha(@accent_bg_color, 0.20);
        }

        .item-subtext {
          font-size: 12px;
          color: @subtext_color;
        }

        .item-quick-activation {
          background: alpha(@accent_bg_color, 0.25);
          border-radius: 5px;
          padding: 4px 8px;
        }

        .preview {
          border: 1px solid alpha(@accent_bg_color, 0.25);
          border-radius: 8px;
          color: @theme_fg_color;
        }

        .preview .large-icons { -gtk-icon-size: 64px; }

        .keybinds {
          padding-top: 8px;
          border-top: 1px solid alpha(@accent_bg_color, 0.15);
          font-size: 12px;
          color: @subtext_color;
        }

        .keybind-bind {
          text-transform: lowercase;
          opacity: 0.5;
        }

        .keybind-label {
          padding: 2px 4px;
          border-radius: 4px;
          border: 1px solid alpha(@theme_fg_color, 0.5);
        }

        .error {
          padding: 10px;
          background: @error_bg_color;
          color: @error_fg_color;
          border-radius: 8px;
        }

        .calc .item-text { font-size: 24px; }
        .symbols .item-image { font-size: 24px; }
      '';
    };

    config = {
      theme = "catppuccin-pill";
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
