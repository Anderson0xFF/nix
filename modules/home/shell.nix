{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-autocomplete";
        src = "${pkgs.zsh-autocomplete}/share/zsh-autocomplete";
        file = "zsh-autocomplete.plugin.zsh";
      }
    ];

    shellAliases = {
      explorer = "yazi";
    };
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
