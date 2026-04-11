{ pkgs, ... }:
{
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    ddcui
  ];

  users.users.alynx.extraGroups = [ "i2c" ];
}
