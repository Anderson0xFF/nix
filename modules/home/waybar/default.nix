{ pkgs, ... }:
let
  mkScript = name: src: vars: pkgs.runCommand name { } ''
    install -Dm755 ${pkgs.replaceVars src vars} $out
  '';

  jq = "${pkgs.jq}/bin/jq";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  makoctl = "${pkgs.mako}/bin/makoctl";
  python = "${pkgs.python3}";
  ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
  ddcui = "${pkgs.ddcui}/bin/ddcui";
  awk = "${pkgs.gawk}/bin/awk";
  cava = "${pkgs.cava}/bin/cava";

  notificationScript = mkScript "waybar-notification" ./scripts/notification.sh {
    inherit jq makoctl;
  };
  distroScript = mkScript "waybar-distro" ./scripts/distro.py {
    inherit python;
  };
  mprisPlayScript = mkScript "waybar-mpris-play" ./scripts/mpris-play.py {
    inherit python playerctl;
  };
  mprisPrevScript = mkScript "waybar-mpris-prev" ./scripts/mpris-prev.py {
    inherit python playerctl;
  };
  mprisNextScript = mkScript "waybar-mpris-next" ./scripts/mpris-next.py {
    inherit python playerctl;
  };
  mprisTitleScript = mkScript "waybar-mpris-title" ./scripts/mpris-title.py {
    inherit python playerctl;
  };
  mprisCmdScript = mkScript "waybar-mpris-cmd" ./scripts/mpris-cmd.py {
    inherit python playerctl;
  };
  cavaScript = mkScript "waybar-cava" ./scripts/cava.py {
    inherit python playerctl cava;
  };
  brightnessScript = mkScript "waybar-brightness" ./scripts/brightness.sh {
    inherit ddcutil awk;
  };

  fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  powerMenuScript = mkScript "waybar-power-menu" ./scripts/power-menu.sh {
    inherit fuzzel hyprlock systemctl;
  };

  compiledStyle = pkgs.runCommand "waybar-style.css" { } ''
    ${pkgs.sassc}/bin/sassc -t expanded ${./style.scss} $out
  '';

  replacements = {
    "@distroScript@" = "${distroScript}";
    "@notificationScript@" = "${notificationScript}";
    "@mprisPrevScript@" = "${mprisPrevScript}";
    "@mprisPlayScript@" = "${mprisPlayScript}";
    "@mprisNextScript@" = "${mprisNextScript}";
    "@mprisTitleScript@" = "${mprisTitleScript}";
    "@mprisCmdScript@" = "${mprisCmdScript}";
    "@cavaScript@" = "${cavaScript}";
    "@brightnessScript@" = "${brightnessScript}";
    "@powerMenuScript@" = "${powerMenuScript}";
    "@ddcutil@" = "${ddcutil}";
    "@ddcui@" = "${ddcui}";
  };

  substitute = s:
    if builtins.isString s then
      builtins.replaceStrings (builtins.attrNames replacements) (builtins.attrValues replacements) s
    else if builtins.isAttrs s then
      builtins.mapAttrs (_: substitute) s
    else if builtins.isList s then
      map substitute s
    else
      s;

  rawSettings = builtins.fromJSON (builtins.readFile ../../../.config/waybar/config.json);
in
{
  programs.waybar = {
    enable = true;
    settings = substitute rawSettings;
    style = builtins.readFile compiledStyle;
  };
}
