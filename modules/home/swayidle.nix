{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = { command = "${pkgs.swaylock-effects}/bin/swaylock -f"; };
      lock = { command = "${pkgs.swaylock-effects}/bin/swaylock -f"; };
    };
    timeouts = [
      { timeout = 300;  command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }   # 5 min → lock
      { timeout = 600;  command = "niri msg action power-off-monitors"; }          # 10 min → monitor off
      { timeout = 1800; command = "${pkgs.systemd}/bin/systemctl suspend"; }       # 30 min → suspend
    ];
  };
}
