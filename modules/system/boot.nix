{ ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.configurationLimit = 10;
  # boot.loader.efiSupport = true;

  # Garbage collection: remove gerações com mais de 7 dias, semanalmente
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Deduplica arquivos idênticos no nix store via hard links
  nix.settings.auto-optimise-store = true;
}
