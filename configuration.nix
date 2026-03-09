{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  # boot.loader.efiSupport = true;

  # Networking
  networking = {
    hostName = "nixos-workstation";
    networkmanager.enable = true;
    enableIPv6 = true;
    # wireless.enable = true;
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
    ];
  };

  # Timezone e localização
  time.timeZone = "America/Sao_Paulo";
  services.xserver.xkb = {
    layout = "us,pt";
    variant = "";
  };
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Fontes
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
      monospace = ["JetBrainsMono Nerd Font"];
      sansSerif = ["Inter"];
      serif = ["Noto Serif"];
    };
  };
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
    noto-fonts
    noto-fonts-color-emoji
    google-fonts
  ];

  # XDG Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    configPackages = [
      pkgs.niri
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Settings" = ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      };
      niri = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Settings" = ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      };
    };
  };

  # Gerenciamento de energia
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;

  # Pacotes de sistema
  environment.systemPackages = with pkgs; [
    git
    wget
    alacritty
    vim
    glib
    gtk3
    gtk4
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    wl-clipboard
    xwayland-satellite
    gsettings-desktop-schemas
    xclip
    libadwaita
  ];

  # Usuário
  users.users.alynx = {
    isNormalUser = true;
    description = "alynx";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Programas
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.niri.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["alynx"];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  system.stateVersion = "25.11";
}
