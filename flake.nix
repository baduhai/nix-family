{
  description = "Nix hosts for the family";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:baduhai/dotfiles";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, dotfiles, nixos-hardware, deploy-rs, ... }: {
    nixosConfigurations = {
      bigghes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/bigghes/configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-9360
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sharpie = import ./users/sharpie_bigghes.nix;
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
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
