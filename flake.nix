{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri-flake, ... }: {
    nixosConfigurations.nixos-workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        niri-flake.nixosModules.niri
        home-manager.nixosModules.home-manager
        ./configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alynx = import ./home.nix;
        }
      ];
    };
  };
}
