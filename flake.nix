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

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri-flake, nix4nvchad, ... }: {
    nixosConfigurations.nixos-workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        niri-flake.nixosModules.niri
        home-manager.nixosModules.home-manager
        ./configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit nix4nvchad; };
          home-manager.users.alynx = import ./home.nix;
        }
      ];
    };
  };
}
