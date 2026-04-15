{ ... }:
{
  # Garbage collection: remove gerações com mais de 7 dias, semanalmente
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Deduplica arquivos idênticos no nix store via hard links
  nix.settings.auto-optimise-store = true;

  # Habilita flakes e o comando nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Aumenta o buffer de download (padrão 64MB) para evitar avisos
  # "download buffer is full" ao baixar muitos store paths em paralelo
  nix.settings.download-buffer-size = 524288000; # 500 MB
 }
