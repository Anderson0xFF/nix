{ ... }:
{
  imports = [
    ./modules/system/nix.nix
    ./modules/system/network.nix
    ./modules/system/i18n.nix
    ./modules/system/fonts.nix
    ./modules/system/portals.nix
    ./modules/system/power.nix
    ./modules/system/performance.nix
    ./modules/system/packages.nix
    ./modules/system/graphics.nix
    ./modules/system/pipewire.nix
    ./modules/system/users.nix
    ./modules/system/programs.nix
    ./modules/system/ssh.nix
    ./modules/system/greetd.nix
    ./modules/system/docker.nix
    ./modules/system/webcam.nix
  ];

  virtualisation.vmware.host.enable = true;

  system.stateVersion = "25.11";
}
