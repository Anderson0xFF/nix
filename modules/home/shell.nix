{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      bindkey -e
    '';
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
