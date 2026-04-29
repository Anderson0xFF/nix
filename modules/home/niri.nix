{ ... }:
{
  programs.niri.config = builtins.readFile ../../.config/niri/niri.kdl;
}
