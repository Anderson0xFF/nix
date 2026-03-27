{ pkgs, ... }:
let
  rustToolchain = pkgs.rust-bin.nightly.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" ];
  };
in
{
  environment.systemPackages = [ rustToolchain ];
}
