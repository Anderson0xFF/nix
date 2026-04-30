{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.procps}/bin/pidof -q hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      lock         = "${pkgs.procps}/bin/pidof -q hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.procps}/bin/pidof -q hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      }
      # Desabilitado: power-off-monitors desconecta o conector DP-1 no driver AMDGPU,
      # matando xwayland-satellite e crashando apps X11 (VMware, etc).
      # { timeout = 600;  command = "niri msg action power-off-monitors"; }
      # Suspend desativado: GPU AMD RX 6700 XT faz MODE1 reset no resume do S3,
      # causando crash de apps Electron (VS Code, Discord). Bug upstream Chromium.
      # { timeout = 1800; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}