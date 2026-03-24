{ ... }:
{
    programs.vscodium = {
        enable = true;
        package = pkgs.vscodium;
        package = pkgs.vscodium.overrideAttrs (old: {
            # sobrescreve o product.json via patch ou postInstall
        });
    }
}