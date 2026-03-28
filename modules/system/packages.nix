{ pkgs, ... }:
{
  imports = [
    ./langs/rust.nix
    ./langs/cpp.nix
  ];

  environment.systemPackages = with pkgs;
    # Ferramentas gerais
    [
      git
      wget
      htop
      firefox
      wl-clipboard
      xwayland-satellite
      xclip
      feh
    ]

    # GTK / Wayland
    ++ [
      glib
      gtk3
      gtk4
      libadwaita
      gsettings-desktop-schemas
    ];

    
}
