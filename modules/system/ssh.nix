{ ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["alynx"];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };
}
