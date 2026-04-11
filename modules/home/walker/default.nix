{ pkgs, ... }:
let
  compiledStyle = pkgs.runCommand "walker-style.css" { } ''
    ${pkgs.sassc}/bin/sassc -t expanded ${./style.scss} $out
  '';
in
{
  programs.walker = {
    enable = true;
    runAsService = true;

    themes.catppuccin-pill = {
      style = builtins.readFile compiledStyle;
    };

    config = {
      theme = "catppuccin-pill";
    };
  };
}
