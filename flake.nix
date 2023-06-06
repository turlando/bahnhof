{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      "bahnhof" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration ];
      };
    };
  };
}
