{ ... }:
{
  networking = {
    # hostName é definido em cada host (hosts/*/default.nix)
    # hostName = "nixos-workstation";
    networkmanager.enable = true;
    enableIPv6 = true;
    # wireless.enable = true;
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
    ];
  };
}
