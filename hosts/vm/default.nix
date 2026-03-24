{ ... }:
{
  imports = [
    ../../configuration.nix
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "nixos-workstation";
}
