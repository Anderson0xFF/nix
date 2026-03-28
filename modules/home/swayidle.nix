{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f";
      lock = "${pkgs.swaylock-effects}/bin/swaylock -f";
    };
    timeouts = [
      { timeout = 300;  command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }   # 5 min → lock
      { timeout = 600;  command = "niri msg action power-off-monitors"; }          # 10 min → monitor off
      # Suspend desativado: GPU AMD RX 6700 XT faz MODE1 reset no resume do S3,
      # causando crash de apps Electron (VS Code, Discord). Bug upstream Chromium.
      # { timeout = 1800; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
