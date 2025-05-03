{
  description = "Nix hosts for the family";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      deploy-rs,
      ...
    }:
    {
      nixosConfigurations = {
        bigghes = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./bigghes/configuration.nix
            nixos-hardware.nixosModules.dell-xps-13-9360
          ];
        };
      };

      deploy = {
        autoRollback = false;
        magicRollback = false;
        user = "root";
        sshUser = "root";
        nodes = {
          "bigghes" = {
            hostname = "100.78.234.41";
            profiles.system = {
              remoteBuild = true;
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bigghes;
            };
          };
        };
      };
    };
}
