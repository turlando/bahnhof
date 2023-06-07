{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      localPkgs = import ./packages { pkgs = nixpkgs.pkgs; };
    in {
      nixosConfigurations = {
        "bahnhof" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            localPkgs = localPkgs;
          };

          modules = [
            ./configuration

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tancredi = import ./home;
              home-manager.extraSpecialArgs = {
                localPkgs = localPkgs;
              };
            }
          ];
        };
      };
  };
}
