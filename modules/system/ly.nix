{ pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      clock = "%c";
      hide_borders = false;
      clear_password = true;
    };
  };

  # ly não importa WAYLAND_DISPLAY para o systemd user antes de spawnar
  # niri-flake-polkit.service, fazendo o polkit-kde-agent crashar em loop
  # (SIGABRT → sem waybar/atalhos no niri).
  systemd.user.services.niri-flake-polkit = {
    after = [ "niri.service" ];
    requires = [ "niri.service" ];
    serviceConfig.ExecStartPre = "${pkgs.bash}/bin/sh -c 'until [ -n \"$WAYLAND_DISPLAY\" ]; do sleep 0.2; done'";
  };
}
