{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      font = "JetBrainsMono Nerd Font";
      font-size = 24;
      fade-in = 0.2;
      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;
      daemonize = true;
      ignore-empty-password = true;

      # Cores (dark theme)
      inside-color = "00000000";
      ring-color = "89b4fa";
      key-hl-color = "a6e3a1";
      bs-hl-color = "f38ba8";
      text-color = "cdd6f4";
      line-color = "00000000";
      separator-color = "00000000";

      inside-clear-color = "00000000";
      ring-clear-color = "fab387";
      text-clear-color = "cdd6f4";
      line-clear-color = "00000000";

      inside-ver-color = "00000000";
      ring-ver-color = "89dceb";
      text-ver-color = "cdd6f4";
      line-ver-color = "00000000";

      inside-wrong-color = "00000000";
      ring-wrong-color = "f38ba8";
      text-wrong-color = "cdd6f4";
      line-wrong-color = "00000000";
    };
  };
}
