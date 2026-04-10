{ pkgs, ... }:
{
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
  ];

  users.users.alynx.extraGroups = [ "i2c" ];
}
