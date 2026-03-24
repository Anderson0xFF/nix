{ pkgs, ... }:
{
  users.users.alynx = {
    isNormalUser = true;
    description = "alynx";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "8192"; }
    { domain = "*"; type = "hard"; item = "nofile"; value = "65536"; }
  ];
}
