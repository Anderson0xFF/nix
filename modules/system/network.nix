{ ... }:
{
  networking = {
    # hostName é definido em cada host (hosts/*/default.nix)
    # hostName = "nixos-workstation";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    enableIPv6 = true;
    # wireless.enable = true;
    nameservers = [
      "1.1.1.1" # Cloudflare
      "9.9.9.9" # Quad9
    ];
  };
}