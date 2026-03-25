{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      bindkey -e
      bindkey "^[[3~" delete-char
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
