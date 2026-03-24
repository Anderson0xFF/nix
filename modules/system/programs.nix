{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.niri.enable = true;
}
