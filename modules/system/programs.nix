{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      postgresql
      postgresql.lib
      openssl
      glib
      gtk3
      gtk4
      libadwaita
      gsettings-desktop-schemas

      # Windowing / input (winit)
      wayland
      libxkbcommon
      libx11
      libxcursor
      libxrandr
      libxi

      # GPU / Vulkan
      vulkan-loader
    ];
  };
  programs.niri.enable = true;
  # Marca a sessão niri como systemd-aware para o xsession-wrapper do NixOS,
  # evitando que ele suba `nixos-fake-graphical-session.target` antes do niri
  # criar o socket Wayland. Sem isso, services com
  # `ConditionEnvironment=WAYLAND_DISPLAY` (walker, elephant) são pulados.
  programs.niri.package = pkgs.niri-unstable.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      substituteInPlace $out/share/wayland-sessions/niri.desktop \
        --replace-fail 'DesktopNames=niri' 'DesktopNames=niri;X-NIXOS-SYSTEMD-AWARE'
    '';
  });
  services.envfs.enable = true;
  security.pam.services.swaylock = {};
}