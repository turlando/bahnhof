{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      localPkgs = import ./packages { pkgs = pkgs; };
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
