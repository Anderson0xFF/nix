{ ... }:
{
  networking = {
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
    resolvconf.enable = false;
  };

  environment.etc."resolv.conf".text = ''
    nameserver 1.1.1.1
    nameserver 9.9.9.9
    options edns0
  '';
}