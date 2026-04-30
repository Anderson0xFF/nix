{ pkgs, ... }:
let
  compiledStyle = pkgs.runCommand "walker-style.css" { } ''
    ${pkgs.sassc}/bin/sassc -t expanded ${../../../.config/walker/themes/catppuccin-pill/style.scss} $out
  '';
in
{
  programs.walker = {
    enable = true;
    runAsService = true;

    themes.catppuccin-pill = {
      style = builtins.readFile compiledStyle;
    };

    config = builtins.fromTOML (builtins.readFile ../../../.config/walker/config.toml);
  };
}
