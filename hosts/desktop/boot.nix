{ pkgs, ... }:
{
  # GRUB com EFI (tela bonita com logo do NixOS)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.grub.theme = pkgs.nixos-grub2-theme;

  # systemd-boot (minimalista, sem tema)
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.configurationLimit = 10;
}
