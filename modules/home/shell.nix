{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = lib.importTOML ../../.config/starship.toml;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
